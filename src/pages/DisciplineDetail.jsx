import { useEffect, useState } from 'react'
import { useParams, Link } from 'react-router-dom'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'
import { computeDisciplineBadges } from '../lib/badges'
import { BadgeGrid, InlineBadges, BadgeUnlocked } from '../components/Badges'
import { FiPlay, FiFileText, FiCheckCircle, FiLock, FiCheck, FiX, FiMessageCircle } from 'react-icons/fi'
import AIChat from '../components/AIChat'
import './DisciplineDetail.css'

function getEmbedUrl(url) {
  if (!url) return null
  let match = url.match(/(?:youtube\.com\/watch\?v=|youtu\.be\/)([\w-]+)/)
  if (match) return `https://www.youtube.com/embed/${match[1]}?rel=0`
  if (url.includes('youtube.com/embed/')) return url
  match = url.match(/vimeo\.com\/(\d+)/)
  if (match) return `https://player.vimeo.com/video/${match[1]}`
  match = url.match(/drive\.google\.com\/file\/d\/([\w-]+)/)
  if (match) return `https://drive.google.com/file/d/${match[1]}/preview`
  return url
}

export default function DisciplineDetail() {
  const { id } = useParams()
  const { user, isAdmin, isMonitor } = useAuth()
  const [discipline, setDiscipline] = useState(null)
  const [lessons, setLessons] = useState([])
  const [materials, setMaterials] = useState([])
  const [completedLessons, setCompletedLessons] = useState(new Set())
  const [activeTab, setActiveTab] = useState('aulas')
  const [activeLesson, setActiveLesson] = useState(null)
  const [loading, setLoading] = useState(true)
  const [hasMonitor, setHasMonitor] = useState(false)

  // Lesson quiz state
  const [lessonQuizQuestions, setLessonQuizQuestions] = useState({})
  const [activeLessonQuiz, setActiveLessonQuiz] = useState(null)
  const [lessonQuizAnswers, setLessonQuizAnswers] = useState({})
  const [lessonQuizSubmitted, setLessonQuizSubmitted] = useState(false)
  const [lessonQuizScore, setLessonQuizScore] = useState(null)
  const [loadingQuiz, setLoadingQuiz] = useState(false)

  // Video watched state
  const [watchedLessons, setWatchedLessons] = useState(new Set())
  const [watchTimers, setWatchTimers] = useState({})
  const [watchReady, setWatchReady] = useState(new Set())

  // Badge state
  const [disciplineBadges, setDisciplineBadges] = useState([])
  const [perfectLessonIds, setPerfectLessonIds] = useState(new Set())
  const [lessonBadges, setLessonBadges] = useState(new Map())
  const [newBadge, setNewBadge] = useState(null)
  const [lessonQuizResultsData, setLessonQuizResultsData] = useState([])
  const [finalQuizResultData, setFinalQuizResultData] = useState(null)

  const completedCount = completedLessons.size
  const allLessonsCompleted = lessons.length > 0 && completedLessons.size >= lessons.length
  const progressPercent = lessons.length > 0 ? Math.round((completedCount / lessons.length) * 100) : 0

  useEffect(() => {
    fetchData()
  }, [id])

  const fetchData = async () => {
    const [discRes, lessonsRes, materialsRes, progressRes, quizResultsRes, finalResultRes, monitorRes] = await Promise.all([
      supabase.from('disciplines').select('*').eq('id', id).single(),
      supabase.from('lessons').select('*').eq('discipline_id', id).order('order_index'),
      supabase.from('materials').select('*').eq('discipline_id', id).order('created_at'),
      supabase.from('lesson_progress').select('lesson_id').eq('user_id', user.id).eq('discipline_id', id),
      supabase.from('lesson_quiz_results').select('lesson_id, discipline_id, score, correct_answers, total_questions').eq('user_id', user.id).eq('discipline_id', id),
      supabase.from('quiz_results').select('discipline_id, score, correct_answers, total_questions').eq('user_id', user.id).eq('discipline_id', id).single(),
      supabase.from('monitor_students').select('monitor_id').eq('student_id', user.id).maybeSingle(),
    ])

    setHasMonitor(!!monitorRes.data)

    if (discRes.data) setDiscipline(discRes.data)
    if (lessonsRes.data) setLessons(lessonsRes.data)
    if (materialsRes.data) setMaterials(materialsRes.data)

    const completedIds = new Set((progressRes.data || []).map(p => p.lesson_id))
    setCompletedLessons(completedIds)

    const quizResults = quizResultsRes.data || []
    setLessonQuizResultsData(quizResults)
    const finalResult = finalResultRes.data || null
    setFinalQuizResultData(finalResult)

    // Compute badges
    if (lessonsRes.data) {
      const badgeResult = computeDisciplineBadges({
        lessons: lessonsRes.data,
        completedLessonIds: completedIds,
        lessonQuizResults: quizResults,
        finalQuizResult: finalResult,
      })
      setDisciplineBadges(badgeResult.badges)
      setPerfectLessonIds(badgeResult.perfectLessonIds)
      setLessonBadges(badgeResult.lessonBadges)
    }

    setLoading(false)
  }

  // Check if lesson is accessible (sequential order)
  const isLessonAccessible = (index) => {
    if (index === 0) return true
    return completedLessons.has(lessons[index - 1].id)
  }

  // Open lesson quiz
  const startLessonQuiz = async (lessonId) => {
    if (lessonQuizQuestions[lessonId]) {
      setActiveLessonQuiz(lessonId)
      setLessonQuizAnswers({})
      setLessonQuizSubmitted(false)
      setLessonQuizScore(null)
      return
    }

    setLoadingQuiz(true)
    const { data } = await supabase
      .from('quiz_questions')
      .select('*')
      .eq('lesson_id', lessonId)
      .order('order_index')
      .limit(3)

    setLessonQuizQuestions(prev => ({ ...prev, [lessonId]: data || [] }))
    setActiveLessonQuiz(lessonId)
    setLessonQuizAnswers({})
    setLessonQuizSubmitted(false)
    setLessonQuizScore(null)
    setLoadingQuiz(false)
  }

  // Handle lesson quiz answer
  const handleLessonQuizAnswer = (questionId, optionIndex) => {
    if (lessonQuizSubmitted) return
    setLessonQuizAnswers(prev => ({ ...prev, [questionId]: optionIndex }))
  }

  // Submit lesson quiz
  const submitLessonQuiz = async (lessonId) => {
    const questions = lessonQuizQuestions[lessonId] || []
    if (Object.keys(lessonQuizAnswers).length < questions.length) {
      alert('Responda todas as questões antes de enviar.')
      return
    }

    let correct = 0
    questions.forEach(q => {
      if (lessonQuizAnswers[q.id] === q.correct_option) correct++
    })

    const total = questions.length
    const passed = correct >= Math.ceil(total * 0.66) // 2/3 corretas
    const scorePercent = Math.round((correct / total) * 100)

    setLessonQuizScore({ correct, total, passed, scorePercent })
    setLessonQuizSubmitted(true)

    // Save quiz result
    await supabase.from('lesson_quiz_results').upsert({
      user_id: user.id,
      lesson_id: lessonId,
      discipline_id: id,
      score: scorePercent,
      total_questions: total,
      correct_answers: correct,
      passed,
      completed_at: new Date().toISOString()
    }, { onConflict: 'user_id,lesson_id' })

    // If passed, mark lesson as completed
    if (passed) {
      await supabase.from('lesson_progress').upsert({
        user_id: user.id,
        lesson_id: lessonId,
        discipline_id: id,
        completed_at: new Date().toISOString()
      }, { onConflict: 'user_id,lesson_id' })

      setCompletedLessons(prev => new Set([...prev, lessonId]))
    }

    // Recompute badges after quiz
    const updatedQuizResults = [...lessonQuizResultsData.filter(r => r.lesson_id !== lessonId), {
      lesson_id: lessonId,
      discipline_id: id,
      score: scorePercent,
      correct_answers: correct,
      total_questions: total,
    }]
    setLessonQuizResultsData(updatedQuizResults)

    const updatedCompletedIds = passed
      ? new Set([...completedLessons, lessonId])
      : completedLessons

    const badgeResult = computeDisciplineBadges({
      lessons,
      completedLessonIds: updatedCompletedIds,
      lessonQuizResults: updatedQuizResults,
      finalQuizResult: finalQuizResultData,
    })

    // Check for new badges
    const oldBadgeIds = new Set(disciplineBadges.map(b => b.id))
    const newBadges = badgeResult.badges.filter(b => !oldBadgeIds.has(b.id))
    if (newBadges.length > 0) {
      setNewBadge(newBadges[0]) // Show first new badge
    }

    // Also check per-lesson badge (quiz perfect)
    if (scorePercent === 100) {
      const prevLessonBadges = lessonBadges.get(lessonId) || []
      if (!prevLessonBadges.some(b => b.id === 'lesson_quiz_perfect')) {
        setNewBadge({ id: 'lesson_quiz_perfect', name: 'Nota Máxima', description: 'Acertou 100% no quiz da aula', icon: '⭐', tier: 'gold' })
      }
    }

    setDisciplineBadges(badgeResult.badges)
    setPerfectLessonIds(badgeResult.perfectLessonIds)
    setLessonBadges(badgeResult.lessonBadges)
  }

  // Mark lesson complete manually (when no quiz questions exist)
  const markLessonComplete = async (lessonId) => {
    await supabase.from('lesson_progress').upsert({
      user_id: user.id,
      lesson_id: lessonId,
      discipline_id: id,
      completed_at: new Date().toISOString()
    }, { onConflict: 'user_id,lesson_id' })

    setCompletedLessons(prev => new Set([...prev, lessonId]))
  }

  // Reset lesson quiz to retry
  const retryLessonQuiz = () => {
    setLessonQuizAnswers({})
    setLessonQuizSubmitted(false)
    setLessonQuizScore(null)
  }

  // Start watch timer when video is opened
  const startWatchTimer = (lessonId) => {
    if (watchedLessons.has(lessonId) || watchReady.has(lessonId)) return
    // Show "Já assisti" button after 10 seconds
    const timer = setTimeout(() => {
      setWatchReady(prev => new Set([...prev, lessonId]))
    }, 10000)
    setWatchTimers(prev => ({ ...prev, [lessonId]: timer }))
  }

  // Clear watch timer
  const clearWatchTimer = (lessonId) => {
    if (watchTimers[lessonId]) {
      clearTimeout(watchTimers[lessonId])
      setWatchTimers(prev => {
        const next = { ...prev }
        delete next[lessonId]
        return next
      })
    }
  }

  // Mark video as watched and auto-open quiz
  const markVideoWatched = async (lessonId) => {
    setWatchedLessons(prev => new Set([...prev, lessonId]))
    // Auto-start the quiz
    startLessonQuiz(lessonId)
  }

  if (loading) {
    return <div className="loading-screen"><div className="spinner"></div></div>
  }

  if (!discipline) {
    return <div className="error-state">Disciplina não encontrada.</div>
  }

  return (
    <div className="discipline-detail">
      <div className="detail-header">
        <Link to="/disciplinas" className="back-link">← Voltar às Disciplinas</Link>
        <div className="detail-title">
          <span className="detail-icon">{discipline.icon || '📖'}</span>
          <div>
            <h1>{discipline.name}</h1>
            <p>{discipline.description}</p>
          </div>
        </div>
      </div>

      {/* Barra de Progresso */}
      {lessons.length > 0 && (
        <div className="progress-section">
          <div className="progress-header">
            <span className="progress-label">Progresso das Aulas</span>
            <span className="progress-value">{completedCount}/{lessons.length} aulas concluídas ({progressPercent}%)</span>
          </div>
          <div className="progress-bar">
            <div className="progress-fill" style={{ width: `${progressPercent}%` }} />
          </div>
          {allLessonsCompleted && (
            <p className="progress-complete-msg">✅ Todas as aulas foram concluídas! O quiz final está liberado.</p>
          )}
        </div>
      )}

      {/* Badges da Disciplina */}
      {disciplineBadges.length > 0 && (
        <div className="detail-badges-section">
          <div className="detail-badges-header">
            <h3>🏅 Conquistas</h3>
            <span className="detail-badges-count">{disciplineBadges.length}</span>
          </div>
          <BadgeGrid badges={disciplineBadges} />
        </div>
      )}

      <div className="tabs">
        <button
          className={`tab ${activeTab === 'aulas' ? 'active' : ''}`}
          onClick={() => setActiveTab('aulas')}
        >
          <FiPlay /> Aulas ({completedLessons.size}/{lessons.length})
        </button>
        <button
          className={`tab ${activeTab === 'materiais' ? 'active' : ''}`}
          onClick={() => setActiveTab('materiais')}
        >
          <FiFileText /> Materiais ({materials.length})
        </button>

        {allLessonsCompleted ? (
          <Link to={`/disciplinas/${id}/quiz`} className="tab tab-quiz tab-quiz-unlocked">
            <FiCheckCircle /> Quiz Final
          </Link>
        ) : (
          <span className="tab tab-quiz tab-quiz-locked" title="Conclua todas as aulas para liberar o quiz final">
            <FiLock /> Quiz Final (bloqueado)
          </span>
        )}
      </div>

      {activeTab === 'aulas' && (
        <div className="lessons-list">
          {lessons.map((lesson, index) => {
            const isCompleted = completedLessons.has(lesson.id)
            const accessible = isLessonAccessible(index)
            const isActive = activeLesson?.id === lesson.id
            const isQuizOpen = activeLessonQuiz === lesson.id
            const quizQuestions = lessonQuizQuestions[lesson.id] || []

            return (
              <div key={lesson.id} className="lesson-wrapper">
                <div className={`lesson-card ${isCompleted ? 'completed' : ''} ${!accessible ? 'locked' : ''} ${isActive ? 'playing' : ''}`}>
                  <div className={`lesson-check ${isCompleted ? 'checked' : ''} ${!accessible ? 'lesson-check-locked' : ''}`}>
                    {isCompleted ? <FiCheck /> : !accessible ? <FiLock /> : <span className="lesson-number-text">{index + 1}</span>}
                  </div>
                  <div className="lesson-info">
                    <h3 className={isCompleted ? 'lesson-done' : ''}>
                      {lesson.title}
                      <InlineBadges badges={lessonBadges.get(lesson.id)?.filter(b => b.id === 'lesson_quiz_perfect') || []} />
                    </h3>
                    {lesson.description && <p>{lesson.description}</p>}
                    {!accessible && <span className="lesson-locked-msg">🔒 Complete a aula anterior primeiro</span>}
                    {isCompleted && <span className="lesson-completed-badge">✅ Concluída</span>}
                  </div>
                  {accessible && lesson.video_url && (
                    <button
                      className={`btn-watch ${isActive ? 'btn-watch-active' : ''}`}
                      onClick={() => {
                        if (isActive) {
                          setActiveLesson(null)
                          setActiveLessonQuiz(null)
                          setLessonQuizSubmitted(false)
                          clearWatchTimer(lesson.id)
                        } else {
                          setActiveLesson(lesson)
                          startWatchTimer(lesson.id)
                        }
                      }}
                    >
                      {isActive ? <><FiX /> Fechar</> : <><FiPlay /> Assistir</>}
                    </button>
                  )}
                </div>

                {/* Video Player */}
                {isActive && (
                  <div className="video-player-inline">
                    <div className="video-wrapper">
                      <iframe
                        src={getEmbedUrl(lesson.video_url)}
                        title={lesson.title}
                        frameBorder="0"
                        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                        allowFullScreen
                      />
                    </div>

                    {/* Lesson quiz trigger / mark complete */}
                    {!isCompleted && !isQuizOpen && !watchedLessons.has(lesson.id) && (
                      <div className="lesson-actions">
                        {watchReady.has(lesson.id) ? (
                          <button
                            className="btn-lesson-watched"
                            onClick={() => markVideoWatched(lesson.id)}
                          >
                            <FiCheck /> Já assisti esta aula — Fazer Quiz
                          </button>
                        ) : (
                          <div className="lesson-watch-notice">
                            <div className="watch-notice-spinner"></div>
                            <span>Assista a aula para liberar o quiz...</span>
                          </div>
                        )}
                      </div>
                    )}
                    {!isCompleted && watchedLessons.has(lesson.id) && !isQuizOpen && (
                      <div className="lesson-actions">
                        <button
                          className="btn-lesson-quiz"
                          onClick={() => startLessonQuiz(lesson.id)}
                          disabled={loadingQuiz}
                        >
                          📝 {loadingQuiz ? 'Carregando...' : 'Fazer Quiz da Aula'}
                        </button>
                      </div>
                    )}
                  </div>
                )}

                {/* Lesson Quiz Inline */}
                {isQuizOpen && (
                  <div className="lesson-quiz-inline">
                    {quizQuestions.length === 0 ? (
                      <div className="lesson-quiz-empty">
                        <p>Nenhuma questão cadastrada para esta aula.</p>
                        <button className="btn-mark-complete" onClick={() => {
                          markLessonComplete(lesson.id)
                          setActiveLessonQuiz(null)
                        }}>
                          <FiCheck /> Marcar Aula como Concluída
                        </button>
                      </div>
                    ) : (
                      <>
                        <div className="lesson-quiz-header">
                          <h4>📝 Quiz da Aula: {lesson.title}</h4>
                          <p>Responda corretamente para concluir esta aula ({quizQuestions.length} questões)</p>
                        </div>

                        {lessonQuizSubmitted && lessonQuizScore && (
                          <div className={`lesson-quiz-result ${lessonQuizScore.passed ? 'passed' : 'failed'}`}>
                            <div className="lq-result-score">{lessonQuizScore.scorePercent}%</div>
                            <div className="lq-result-detail">
                              {lessonQuizScore.correct} de {lessonQuizScore.total} acertos
                            </div>
                            <div className="lq-result-text">
                              {lessonQuizScore.passed
                                ? '🎉 Aprovado! Aula concluída com sucesso.'
                                : '😕 Não atingiu a pontuação mínima. Revise o conteúdo e tente novamente.'}
                            </div>
                            {!lessonQuizScore.passed && (
                              <button className="btn-retry-lesson" onClick={retryLessonQuiz}>
                                🔄 Tentar Novamente
                              </button>
                            )}
                            {lessonQuizScore.passed && (
                              <button className="btn-next-lesson" onClick={() => {
                                setActiveLessonQuiz(null)
                                setActiveLesson(null)
                              }}>
                                Continuar →
                              </button>
                            )}
                          </div>
                        )}

                        <div className="lesson-quiz-questions">
                          {quizQuestions.map((q, qIndex) => (
                            <div key={q.id} className="lq-question-card">
                              <span className="lq-question-number">Questão {qIndex + 1}</span>
                              <p className="lq-question-text">{q.question}</p>
                              <div className="lq-options">
                                {q.options.map((option, oIndex) => {
                                  let cls = 'lq-option'
                                  if (lessonQuizAnswers[q.id] === oIndex) cls += ' selected'
                                  if (lessonQuizSubmitted) {
                                    if (oIndex === q.correct_option) cls += ' correct'
                                    else if (lessonQuizAnswers[q.id] === oIndex) cls += ' wrong'
                                  }
                                  return (
                                    <button
                                      key={oIndex}
                                      className={cls}
                                      onClick={() => handleLessonQuizAnswer(q.id, oIndex)}
                                      disabled={lessonQuizSubmitted}
                                    >
                                      <span className="lq-option-letter">{String.fromCharCode(65 + oIndex)}</span>
                                      <span>{option}</span>
                                    </button>
                                  )
                                })}
                              </div>

                              {lessonQuizSubmitted && q.correction_comment && (
                                <div className="correction-comment">
                                  <span className="correction-comment-icon">💡</span>
                                  <div className="correction-comment-text">{q.correction_comment}</div>
                                </div>
                              )}
                            </div>
                          ))}
                        </div>

                        {!lessonQuizSubmitted && (
                          <button
                            className="btn-submit-lesson-quiz"
                            onClick={() => submitLessonQuiz(lesson.id)}
                          >
                            Enviar Respostas ({Object.keys(lessonQuizAnswers).length}/{quizQuestions.length})
                          </button>
                        )}
                      </>
                    )}
                  </div>
                )}
              </div>
            )
          })}

          {lessons.length === 0 && (
            <div className="empty-state">
              <p>Nenhuma aula cadastrada para esta disciplina.</p>
            </div>
          )}
        </div>
      )}

      {activeTab === 'materiais' && (
        <div className="materials-list">
          {materials.map((mat) => (
            <a
              key={mat.id}
              href={mat.url}
              target="_blank"
              rel="noopener noreferrer"
              className="material-card"
            >
              <div className="material-type">{getTypeIcon(mat.type)}</div>
              <div className="material-info">
                <h3>{mat.title}</h3>
                <span className="material-badge">{mat.type}</span>
              </div>
            </a>
          ))}

          {materials.length === 0 && (
            <div className="empty-state">
              <p>Nenhum material disponível para esta disciplina.</p>
            </div>
          )}
        </div>
      )}

      {/* Botão de tirar dúvida - visível para alunos com monitor */}
      {!isAdmin && !isMonitor && hasMonitor && (
        <div className="doubt-cta-section">
          <div className="doubt-cta-content">
            <FiMessageCircle className="doubt-cta-icon" />
            <div>
              <h3>Tem alguma dúvida sobre esta disciplina?</h3>
              <p>Envie sua dúvida para seu monitor e receba uma resposta.</p>
            </div>
          </div>
          <Link to={`/minhas-duvidas?disciplina=${id}`} className="btn-doubt-cta">
            <FiMessageCircle /> Tirar Dúvida
          </Link>
        </div>
      )}

      <AIChat discipline={discipline} lessons={lessons} materials={materials} />

      {/* Badge Unlocked Popup */}
      {newBadge && <BadgeUnlocked badge={newBadge} onClose={() => setNewBadge(null)} />}
    </div>
  )
}

function getTypeIcon(type) {
  switch (type?.toLowerCase()) {
    case 'livro': return '📕'
    case 'artigo': return '📄'
    case 'pdf': return '📑'
    case 'link': return '🔗'
    default: return '📎'
  }
}
