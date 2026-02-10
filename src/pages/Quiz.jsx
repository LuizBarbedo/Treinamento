import { useEffect, useState } from 'react'
import { useParams, Link } from 'react-router-dom'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'
import { computeDisciplineBadges } from '../lib/badges'
import { BadgeUnlocked } from '../components/Badges'
import { FiLock } from 'react-icons/fi'
import AIChat from '../components/AIChat'
import './Quiz.css'

export default function Quiz() {
  const { id } = useParams()
  const { user } = useAuth()
  const [discipline, setDiscipline] = useState(null)
  const [questions, setQuestions] = useState([])
  const [answers, setAnswers] = useState({})
  const [submitted, setSubmitted] = useState(false)
  const [score, setScore] = useState(null)
  const [loading, setLoading] = useState(true)
  const [contentCompleted, setContentCompleted] = useState(false)
  const [totalLessons, setTotalLessons] = useState(0)
  const [completedLessonsCount, setCompletedLessonsCount] = useState(0)
  const [newBadge, setNewBadge] = useState(null)

  useEffect(() => {
    fetchQuiz()
  }, [id])

  const fetchQuiz = async () => {
    const [discRes, questionsRes, lessonsRes, progressRes] = await Promise.all([
      supabase.from('disciplines').select('*').eq('id', id).single(),
      supabase.from('quiz_questions').select('*').eq('discipline_id', id).is('lesson_id', null).order('order_index').limit(10),
      supabase.from('lessons').select('id').eq('discipline_id', id),
      supabase.from('lesson_progress').select('lesson_id').eq('user_id', user.id).eq('discipline_id', id)
    ])

    if (discRes.data) setDiscipline(discRes.data)
    if (questionsRes.data) setQuestions(questionsRes.data)

    const total = lessonsRes.data?.length || 0
    const completed = progressRes.data?.length || 0
    setTotalLessons(total)
    setCompletedLessonsCount(completed)

    // Quiz liberado se completou todas as aulas (ou se não há aulas cadastradas)
    setContentCompleted(total === 0 || completed >= total)
    setLoading(false)
  }

  const handleAnswer = (questionId, optionIndex) => {
    if (submitted) return
    setAnswers(prev => ({ ...prev, [questionId]: optionIndex }))
  }

  const handleSubmit = async () => {
    if (Object.keys(answers).length < questions.length) {
      alert('Por favor, responda todas as questões antes de enviar.')
      return
    }

    let correct = 0
    questions.forEach(q => {
      if (answers[q.id] === q.correct_option) {
        correct++
      }
    })

    const finalScore = Math.round((correct / questions.length) * 100)
    setScore(finalScore)
    setSubmitted(true)

    // Salvar resultado
    await supabase.from('quiz_results').upsert({
      user_id: user.id,
      discipline_id: id,
      score: finalScore,
      total_questions: questions.length,
      correct_answers: correct,
      completed_at: new Date().toISOString()
    }, {
      onConflict: 'user_id,discipline_id'
    })

    // Atualizar progresso se passou (>= 70%)
    if (finalScore >= 70) {
      await supabase.from('user_progress').upsert({
        user_id: user.id,
        discipline_id: id,
        completed: true,
        completed_at: new Date().toISOString()
      }, {
        onConflict: 'user_id,discipline_id'
      })
    }

    // Compute badges for the quiz result
    if (finalScore >= 70) {
      // Fetch data needed for badge computation
      const [lessonsRes, progressRes, quizResultsRes] = await Promise.all([
        supabase.from('lessons').select('*').eq('discipline_id', id),
        supabase.from('lesson_progress').select('lesson_id').eq('user_id', user.id).eq('discipline_id', id),
        supabase.from('lesson_quiz_results').select('lesson_id, score, correct_answers, total_questions').eq('user_id', user.id).eq('discipline_id', id),
      ])

      const lessonsData = lessonsRes.data || []
      const completedIds = new Set((progressRes.data || []).map(p => p.lesson_id))
      const quizResults = quizResultsRes.data || []
      const finalResult = { score: finalScore, correct_answers: correct, total_questions: questions.length }

      const { badges } = computeDisciplineBadges({
        lessons: lessonsData,
        completedLessonIds: completedIds,
        lessonQuizResults: quizResults,
        finalQuizResult: finalResult,
      })

      // Show the most notable new badge
      if (finalScore === 100) {
        const masterBadge = badges.find(b => b.id === 'discipline_master')
        const perfectBadge = badges.find(b => b.id === 'final_quiz_perfect')
        setNewBadge(masterBadge || perfectBadge || null)
      } else {
        const passedBadge = badges.find(b => b.id === 'final_quiz_passed')
        setNewBadge(passedBadge || null)
      }
    }
  }

  const resetQuiz = () => {
    setAnswers({})
    setSubmitted(false)
    setScore(null)
  }

  if (loading) {
    return <div className="loading-screen"><div className="spinner"></div></div>
  }

  if (!discipline) {
    return <div className="error-state">Disciplina não encontrada.</div>
  }

  // Tela de bloqueio se o conteúdo não foi concluído
  if (!contentCompleted) {
    return (
      <div className="quiz-page">
        <Link to={`/disciplinas/${id}`} className="back-link">← Voltar para {discipline.name}</Link>

        <div className="quiz-locked">
          <div className="locked-icon"><FiLock /></div>
          <h2>Quiz Bloqueado</h2>
          <p>
            Você precisa concluir todo o conteúdo da disciplina <strong>{discipline.name}</strong> antes de fazer o quiz.
          </p>
          <div className="locked-progress">
            <div className="locked-progress-bar">
              <div
                className="locked-progress-fill"
                style={{ width: `${totalLessons > 0 ? Math.round((completedLessonsCount / totalLessons) * 100) : 0}%` }}
              />
            </div>
            <span className="locked-progress-text">
              {completedLessonsCount} de {totalLessons} aulas concluídas
            </span>
          </div>
          <Link to={`/disciplinas/${id}`} className="btn-go-back">
            Continuar Estudando
          </Link>
        </div>
      </div>
    )
  }

  return (
    <div className="quiz-page">
      <Link to={`/disciplinas/${id}`} className="back-link">← Voltar para {discipline.name}</Link>

      <div className="quiz-header">
        <h1>📝 Quiz Final: {discipline.name}</h1>
        <p>Avaliação geral da disciplina. Responda todas as questões abaixo. Você precisa de pelo menos <strong>70%</strong> de acertos para ser aprovado.</p>
        <div className="quiz-info-bar">
          <span>📋 {questions.length} questões</span>
          <span>✅ Mínimo: 70%</span>
          <span>🔄 Pode refazer</span>
        </div>
      </div>

      {submitted && (
        <div className={`quiz-result ${score >= 70 ? 'passed' : 'failed'}`}>
          <div className="result-score">{score}%</div>
          <div className="result-detail">
            {Math.round(score * questions.length / 100)} de {questions.length} acertos
          </div>
          <div className="result-text">
            {score >= 70
              ? '🎉 Parabéns! Você foi aprovado nesta disciplina!'
              : '😕 Você não atingiu a pontuação mínima. Revise o conteúdo e tente novamente!'}
          </div>
          <button className="btn-retry" onClick={resetQuiz}>
            Refazer Avaliação
          </button>
        </div>
      )}

      {questions.length === 0 ? (
        <div className="empty-state">
          <p>Nenhuma questão cadastrada para esta disciplina.</p>
        </div>
      ) : (
        <div className="questions-list">
          {questions.map((q, qIndex) => (
            <div key={q.id} className="question-card">
              <div className="question-header">
                <span className="question-number">Questão {qIndex + 1} de {questions.length}</span>
              </div>
              <p className="question-text">{q.question}</p>

              <div className="options-list">
                {q.options.map((option, oIndex) => {
                  let optionClass = 'option'
                  if (answers[q.id] === oIndex) optionClass += ' selected'
                  if (submitted) {
                    if (oIndex === q.correct_option) optionClass += ' correct'
                    else if (answers[q.id] === oIndex) optionClass += ' wrong'
                  }

                  return (
                    <button
                      key={oIndex}
                      className={optionClass}
                      onClick={() => handleAnswer(q.id, oIndex)}
                      disabled={submitted}
                    >
                      <span className="option-letter">
                        {String.fromCharCode(65 + oIndex)}
                      </span>
                      <span className="option-text">{option}</span>
                    </button>
                  )
                })}
              </div>

              {submitted && q.correction_comment && (
                <div className="correction-comment">
                  <span className="correction-comment-icon">💡</span>
                  <div className="correction-comment-text">{q.correction_comment}</div>
                </div>
              )}
            </div>
          ))}

          {!submitted && (
            <button className="btn-submit-quiz" onClick={handleSubmit}>
              Enviar Respostas ({Object.keys(answers).length}/{questions.length} respondidas)
            </button>
          )}
        </div>
      )}

      <AIChat discipline={discipline} lessons={[]} materials={[]} />

      {/* Badge Unlocked Popup */}
      {newBadge && <BadgeUnlocked badge={newBadge} onClose={() => setNewBadge(null)} />}
    </div>
  )
}
