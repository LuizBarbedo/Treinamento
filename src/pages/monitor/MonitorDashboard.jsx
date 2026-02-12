import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { supabase } from '../../lib/supabase'
import { useAuth } from '../../contexts/AuthContext'
import { FiUsers, FiMessageCircle, FiAlertCircle, FiCheckCircle, FiTrendingUp, FiChevronRight } from 'react-icons/fi'
import './MonitorDashboard.css'

export default function MonitorDashboard() {
  const { user } = useAuth()
  const [loading, setLoading] = useState(true)
  const [students, setStudents] = useState([])
  const [pendingDoubts, setPendingDoubts] = useState(0)
  const [recentDoubts, setRecentDoubts] = useState([])
  const [disciplines, setDisciplines] = useState([])
  const [allProgress, setAllProgress] = useState([])
  const [allQuizResults, setAllQuizResults] = useState([])

  useEffect(() => {
    if (user) fetchData()
  }, [user])

  const fetchData = async () => {
    try {
      // Buscar alunos vinculados ao monitor
      const { data: studentsList } = await supabase.rpc('get_monitor_students', {
        p_monitor_id: user.id
      })

      const studentsData = studentsList || []
      setStudents(studentsData)

      if (studentsData.length === 0) {
        setLoading(false)
        return
      }

      const studentIds = studentsData.map(s => s.id)

      // Buscar dados em paralelo
      const [discRes, progressRes, quizRes, doubtsRes, pendingRes] = await Promise.all([
        supabase.from('disciplines').select('*').order('order_index'),
        supabase.from('user_progress').select('*').in('user_id', studentIds),
        supabase.from('quiz_results').select('*').in('user_id', studentIds),
        supabase.from('doubts').select('*, disciplines(name), lessons(title)')
          .in('user_id', studentIds)
          .order('created_at', { ascending: false })
          .limit(5),
        supabase.rpc('get_monitor_pending_doubts_count', { p_monitor_id: user.id })
      ])

      setDisciplines(discRes.data || [])
      setAllProgress(progressRes.data || [])
      setAllQuizResults(quizRes.data || [])
      setRecentDoubts(doubtsRes.data || [])
      setPendingDoubts(pendingRes.data || 0)
    } catch (err) {
      console.error('Erro ao buscar dados do monitor:', err)
    } finally {
      setLoading(false)
    }
  }

  const getStudentStats = (studentId) => {
    const progress = allProgress.filter(p => p.user_id === studentId)
    const completed = progress.filter(p => p.completed).length
    const quizResults = allQuizResults.filter(q => q.user_id === studentId)
    const avgScore = quizResults.length > 0
      ? Math.round(quizResults.reduce((sum, q) => sum + (q.score || 0), 0) / quizResults.length)
      : null

    return { completed, total: disciplines.length, avgScore }
  }

  const getStatusColor = (status) => {
    switch (status) {
      case 'open': return 'status-open'
      case 'answered': return 'status-answered'
      case 'resolved': return 'status-resolved'
      default: return ''
    }
  }

  const getStatusLabel = (status) => {
    switch (status) {
      case 'open': return 'Aberta'
      case 'answered': return 'Respondida'
      case 'resolved': return 'Resolvida'
      default: return status
    }
  }

  const getStudentName = (userId) => {
    const student = students.find(s => s.id === userId)
    return student?.full_name || student?.email || 'Aluno'
  }

  if (loading) {
    return (
      <div className="monitor-dashboard">
        <div className="loading-screen">
          <div className="spinner"></div>
          <p>Carregando painel do monitor...</p>
        </div>
      </div>
    )
  }

  return (
    <div className="monitor-dashboard">
      <div className="monitor-header">
        <h1>📋 Painel do Monitor</h1>
        <p>Acompanhe o progresso dos seus alunos e responda dúvidas</p>
      </div>

      {/* Stats Cards */}
      <div className="monitor-stats-grid">
        <div className="monitor-stat-card">
          <FiUsers className="monitor-stat-icon" />
          <div>
            <span className="monitor-stat-number">{students.length}</span>
            <span className="monitor-stat-label">Alunos</span>
          </div>
        </div>
        <div className="monitor-stat-card">
          <FiAlertCircle className="monitor-stat-icon warning" />
          <div>
            <span className="monitor-stat-number">{pendingDoubts}</span>
            <span className="monitor-stat-label">Dúvidas Pendentes</span>
          </div>
        </div>
        <div className="monitor-stat-card">
          <FiCheckCircle className="monitor-stat-icon success" />
          <div>
            <span className="monitor-stat-number">
              {allProgress.filter(p => p.completed).length}
            </span>
            <span className="monitor-stat-label">Disciplinas Concluídas</span>
          </div>
        </div>
        <div className="monitor-stat-card">
          <FiTrendingUp className="monitor-stat-icon" />
          <div>
            <span className="monitor-stat-number">
              {allQuizResults.length > 0
                ? Math.round(allQuizResults.reduce((s, q) => s + (q.score || 0), 0) / allQuizResults.length) + '%'
                : '—'
              }
            </span>
            <span className="monitor-stat-label">Média Geral</span>
          </div>
        </div>
      </div>

      <div className="monitor-content-grid">
        {/* Lista de Alunos */}
        <div className="monitor-section">
          <div className="monitor-section-header">
            <h2><FiUsers /> Meus Alunos</h2>
            <Link to="/monitor/alunos" className="btn-see-all">Ver todos →</Link>
          </div>

          {students.length === 0 ? (
            <div className="monitor-empty">
              <p>Nenhum aluno vinculado ainda.</p>
              <p className="empty-hint">O administrador irá vincular alunos ao seu perfil.</p>
            </div>
          ) : (
            <div className="monitor-students-list">
              {students.slice(0, 5).map(student => {
                const stats = getStudentStats(student.id)
                return (
                  <Link
                    key={student.id}
                    to={`/monitor/alunos/${student.id}`}
                    className="monitor-student-card"
                  >
                    <div className="student-info">
                      <span className="student-avatar">
                        {(student.full_name || student.email || '?')[0].toUpperCase()}
                      </span>
                      <div>
                        <span className="student-name">{student.full_name || student.email}</span>
                        <span className="student-email">{student.email}</span>
                      </div>
                    </div>
                    <div className="student-metrics">
                      <span className="metric">
                        {stats.completed}/{stats.total} disciplinas
                      </span>
                      {stats.avgScore !== null && (
                        <span className={`metric ${stats.avgScore >= 70 ? 'good' : 'warning'}`}>
                          Média: {stats.avgScore}%
                        </span>
                      )}
                    </div>
                    <FiChevronRight className="chevron" />
                  </Link>
                )
              })}
            </div>
          )}
        </div>

        {/* Dúvidas Recentes */}
        <div className="monitor-section">
          <div className="monitor-section-header">
            <h2><FiMessageCircle /> Dúvidas Recentes</h2>
            <Link to="/monitor/duvidas" className="btn-see-all">Ver todas →</Link>
          </div>

          {recentDoubts.length === 0 ? (
            <div className="monitor-empty">
              <p>Nenhuma dúvida registrada.</p>
            </div>
          ) : (
            <div className="monitor-doubts-list">
              {recentDoubts.map(doubt => (
                <Link
                  key={doubt.id}
                  to={`/monitor/duvidas/${doubt.id}`}
                  className="monitor-doubt-card"
                >
                  <div className="doubt-header">
                    <span className={`doubt-status ${getStatusColor(doubt.status)}`}>
                      {getStatusLabel(doubt.status)}
                    </span>
                    <span className="doubt-date">
                      {new Date(doubt.created_at).toLocaleDateString('pt-BR')}
                    </span>
                  </div>
                  <h4 className="doubt-title">{doubt.title}</h4>
                  <div className="doubt-meta">
                    <span>{getStudentName(doubt.user_id)}</span>
                    <span>{doubt.disciplines?.name}</span>
                    {doubt.lessons?.title && <span>{doubt.lessons.title}</span>}
                  </div>
                </Link>
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  )
}
