import { useEffect, useState } from 'react'
import { useParams, Link } from 'react-router-dom'
import { supabase } from '../../lib/supabase'
import { useAuth } from '../../contexts/AuthContext'
import { FiArrowLeft, FiBook, FiCheckCircle, FiClock, FiAward, FiMessageCircle, FiChevronDown, FiChevronUp } from 'react-icons/fi'
import './MonitorStudentDetail.css'

export default function MonitorStudentDetail() {
  const { studentId } = useParams()
  const { user } = useAuth()
  const [loading, setLoading] = useState(true)
  const [student, setStudent] = useState(null)
  const [disciplines, setDisciplines] = useState([])
  const [lessons, setLessons] = useState([])
  const [progress, setProgress] = useState([])
  const [quizResults, setQuizResults] = useState([])
  const [lessonProgress, setLessonProgress] = useState([])
  const [lessonQuizResults, setLessonQuizResults] = useState([])
  const [doubts, setDoubts] = useState([])
  const [expandedDisc, setExpandedDisc] = useState(null)

  useEffect(() => {
    if (user && studentId) fetchData()
  }, [user, studentId])

  const fetchData = async () => {
    try {
      // Buscar dados do aluno
      const { data: students } = await supabase.rpc('get_monitor_students', {
        p_monitor_id: user.id
      })
      const studentData = (students || []).find(s => s.id === studentId)
      if (!studentData) {
        setLoading(false)
        return
      }
      setStudent(studentData)

      // Buscar todos os dados em paralelo
      const [discRes, lessonsRes, progRes, quizRes, lesProg, lesQuiz, doubtsRes] = await Promise.all([
        supabase.from('disciplines').select('*').order('order_index'),
        supabase.from('lessons').select('*').order('order_index'),
        supabase.from('user_progress').select('*').eq('user_id', studentId),
        supabase.from('quiz_results').select('*').eq('user_id', studentId),
        supabase.from('lesson_progress').select('*').eq('user_id', studentId),
        supabase.from('lesson_quiz_results').select('*').eq('user_id', studentId),
        supabase.from('doubts').select('*, disciplines(name), lessons(title)')
          .eq('user_id', studentId)
          .order('created_at', { ascending: false }),
      ])

      setDisciplines(discRes.data || [])
      setLessons(lessonsRes.data || [])
      setProgress(progRes.data || [])
      setQuizResults(quizRes.data || [])
      setLessonProgress(lesProg.data || [])
      setLessonQuizResults(lesQuiz.data || [])
      setDoubts(doubtsRes.data || [])
    } catch (err) {
      console.error('Erro ao buscar dados do aluno:', err)
    } finally {
      setLoading(false)
    }
  }

  const getDiscProgress = (discId) => {
    const discLessons = lessons.filter(l => l.discipline_id === discId)
    const completedLessons = lessonProgress.filter(lp => lp.discipline_id === discId)
    const isCompleted = progress.some(p => p.discipline_id === discId && p.completed)
    const finalQuiz = quizResults.find(q => q.discipline_id === discId)

    return {
      totalLessons: discLessons.length,
      completedLessons: completedLessons.length,
      isCompleted,
      finalQuiz,
      lessons: discLessons,
    }
  }

  const getLessonQuiz = (lessonId) => {
    return lessonQuizResults.find(lq => lq.lesson_id === lessonId)
  }

  const isLessonCompleted = (lessonId) => {
    return lessonProgress.some(lp => lp.lesson_id === lessonId)
  }

  const getStatusLabel = (status) => {
    switch (status) {
      case 'open': return 'Aberta'
      case 'answered': return 'Respondida'
      case 'resolved': return 'Resolvida'
      default: return status
    }
  }

  if (loading) {
    return (
      <div className="student-detail-page">
        <div className="loading-screen">
          <div className="spinner"></div>
          <p>Carregando dados do aluno...</p>
        </div>
      </div>
    )
  }

  if (!student) {
    return (
      <div className="student-detail-page">
        <div className="empty-state">
          <p>Aluno não encontrado ou sem permissão.</p>
          <Link to="/monitor/alunos" className="btn-back">← Voltar</Link>
        </div>
      </div>
    )
  }

  const totalCompleted = progress.filter(p => p.completed).length
  const avgScore = quizResults.length > 0
    ? Math.round(quizResults.reduce((s, q) => s + (q.score || 0), 0) / quizResults.length)
    : null

  return (
    <div className="student-detail-page">
      <Link to="/monitor/alunos" className="btn-back"><FiArrowLeft /> Voltar para Alunos</Link>

      {/* Header do aluno */}
      <div className="student-profile">
        <div className="student-avatar-lg">
          {(student.full_name || student.email || '?')[0].toUpperCase()}
        </div>
        <div className="student-profile-info">
          <h1>{student.full_name || student.email}</h1>
          <p>{student.email}</p>
          <span className="student-since">
            Vinculado desde {new Date(student.assigned_at).toLocaleDateString('pt-BR')}
          </span>
        </div>
      </div>

      {/* Stats do aluno */}
      <div className="student-stats-grid">
        <div className="student-stat">
          <FiBook />
          <div>
            <strong>{totalCompleted}/{disciplines.length}</strong>
            <span>Disciplinas</span>
          </div>
        </div>
        <div className="student-stat">
          <FiCheckCircle />
          <div>
            <strong>{lessonProgress.length}</strong>
            <span>Aulas Concluídas</span>
          </div>
        </div>
        <div className="student-stat">
          <FiAward />
          <div>
            <strong>{avgScore !== null ? `${avgScore}%` : '—'}</strong>
            <span>Média Quiz Final</span>
          </div>
        </div>
        <div className="student-stat">
          <FiMessageCircle />
          <div>
            <strong>{doubts.length}</strong>
            <span>Dúvidas</span>
          </div>
        </div>
      </div>

      {/* Progresso por disciplina */}
      <div className="detail-section">
        <h2>📚 Progresso por Disciplina</h2>
        <div className="disc-progress-list">
          {disciplines.map(disc => {
            const dp = getDiscProgress(disc.id)
            const pct = dp.totalLessons > 0
              ? Math.round((dp.completedLessons / dp.totalLessons) * 100)
              : 0
            const isExpanded = expandedDisc === disc.id

            return (
              <div key={disc.id} className="disc-progress-item">
                <div
                  className="disc-progress-header"
                  onClick={() => setExpandedDisc(isExpanded ? null : disc.id)}
                >
                  <div className="disc-info">
                    <span className="disc-icon">{disc.icon || '📚'}</span>
                    <div>
                      <span className="disc-name">{disc.name}</span>
                      <span className="disc-stats-text">
                        {dp.completedLessons}/{dp.totalLessons} aulas
                        {dp.finalQuiz && ` • Quiz: ${dp.finalQuiz.score}%`}
                      </span>
                    </div>
                  </div>
                  <div className="disc-right">
                    {dp.isCompleted ? (
                      <span className="disc-badge completed">✅ Concluída</span>
                    ) : pct > 0 ? (
                      <span className="disc-badge in-progress">{pct}%</span>
                    ) : (
                      <span className="disc-badge not-started">Não iniciado</span>
                    )}
                    {isExpanded ? <FiChevronUp /> : <FiChevronDown />}
                  </div>
                </div>

                {isExpanded && (
                  <div className="disc-lessons-detail">
                    {dp.lessons.map(lesson => {
                      const completed = isLessonCompleted(lesson.id)
                      const quiz = getLessonQuiz(lesson.id)
                      return (
                        <div key={lesson.id} className={`lesson-row ${completed ? 'completed' : ''}`}>
                          <span className="lesson-status-icon">
                            {completed ? <FiCheckCircle className="icon-completed" /> : <FiClock className="icon-pending" />}
                          </span>
                          <span className="lesson-title">{lesson.title}</span>
                          {quiz && (
                            <span className={`lesson-quiz-score ${quiz.score >= 70 ? 'good' : 'low'}`}>
                              Quiz: {quiz.score}%
                            </span>
                          )}
                        </div>
                      )
                    })}
                    {dp.lessons.length === 0 && (
                      <p className="no-lessons">Nenhuma aula cadastrada</p>
                    )}
                  </div>
                )}
              </div>
            )
          })}
        </div>
      </div>

      {/* Dúvidas do aluno */}
      <div className="detail-section">
        <h2>💬 Dúvidas do Aluno</h2>
        {doubts.length === 0 ? (
          <p className="no-data">Nenhuma dúvida registrada.</p>
        ) : (
          <div className="student-doubts-list">
            {doubts.map(doubt => (
              <Link key={doubt.id} to={`/monitor/duvidas/${doubt.id}`} className="student-doubt-item">
                <div className="doubt-header">
                  <span className={`doubt-status status-${doubt.status}`}>
                    {getStatusLabel(doubt.status)}
                  </span>
                  <span className="doubt-date">
                    {new Date(doubt.created_at).toLocaleDateString('pt-BR')}
                  </span>
                </div>
                <h4>{doubt.title}</h4>
                <p className="doubt-desc">{doubt.description?.substring(0, 120)}...</p>
                <span className="doubt-disc">{doubt.disciplines?.name}</span>
              </Link>
            ))}
          </div>
        )}
      </div>
    </div>
  )
}
