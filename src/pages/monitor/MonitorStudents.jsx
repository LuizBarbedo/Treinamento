import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { supabase } from '../../lib/supabase'
import { useAuth } from '../../contexts/AuthContext'
import { FiChevronRight, FiSearch } from 'react-icons/fi'
import './MonitorStudents.css'

export default function MonitorStudents() {
  const { user } = useAuth()
  const [loading, setLoading] = useState(true)
  const [students, setStudents] = useState([])
  const [disciplines, setDisciplines] = useState([])
  const [allProgress, setAllProgress] = useState([])
  const [allQuizResults, setAllQuizResults] = useState([])
  const [allLessonProgress, setAllLessonProgress] = useState([])
  const [searchTerm, setSearchTerm] = useState('')

  useEffect(() => {
    if (user) fetchData()
  }, [user])

  const fetchData = async () => {
    try {
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

      const [discRes, progressRes, quizRes, lessonProgRes] = await Promise.all([
        supabase.from('disciplines').select('*').order('order_index'),
        supabase.from('user_progress').select('*').in('user_id', studentIds),
        supabase.from('quiz_results').select('*').in('user_id', studentIds),
        supabase.from('lesson_progress').select('*').in('user_id', studentIds),
      ])

      setDisciplines(discRes.data || [])
      setAllProgress(progressRes.data || [])
      setAllQuizResults(quizRes.data || [])
      setAllLessonProgress(lessonProgRes.data || [])
    } catch (err) {
      console.error('Erro ao buscar alunos:', err)
    } finally {
      setLoading(false)
    }
  }

  const getStudentStats = (studentId) => {
    const progress = allProgress.filter(p => p.user_id === studentId)
    const completed = progress.filter(p => p.completed).length
    const quizResults = allQuizResults.filter(q => q.user_id === studentId)
    const lessonProg = allLessonProgress.filter(l => l.user_id === studentId)
    const avgScore = quizResults.length > 0
      ? Math.round(quizResults.reduce((sum, q) => sum + (q.score || 0), 0) / quizResults.length)
      : null

    // Disciplinas em andamento (tem progresso mas não concluiu)
    const completedIds = new Set(progress.filter(p => p.completed).map(p => p.discipline_id))
    const inProgressIds = new Set()
    lessonProg.forEach(lp => {
      if (!completedIds.has(lp.discipline_id)) inProgressIds.add(lp.discipline_id)
    })

    return {
      completed,
      inProgress: inProgressIds.size,
      total: disciplines.length,
      avgScore,
      quizCount: quizResults.length,
      lessonsCompleted: lessonProg.length,
    }
  }

  const filteredStudents = students.filter(s => {
    const term = searchTerm.toLowerCase()
    return (s.full_name || '').toLowerCase().includes(term) ||
           (s.email || '').toLowerCase().includes(term)
  })

  if (loading) {
    return (
      <div className="monitor-students-page">
        <div className="loading-screen">
          <div className="spinner"></div>
          <p>Carregando alunos...</p>
        </div>
      </div>
    )
  }

  return (
    <div className="monitor-students-page">
      <div className="page-header">
        <h1>👥 Meus Alunos</h1>
        <p>{students.length} aluno{students.length !== 1 ? 's' : ''} vinculado{students.length !== 1 ? 's' : ''}</p>
      </div>

      {students.length > 0 && (
        <div className="search-bar">
          <FiSearch />
          <input
            type="text"
            placeholder="Buscar aluno por nome ou email..."
            value={searchTerm}
            onChange={e => setSearchTerm(e.target.value)}
          />
        </div>
      )}

      {filteredStudents.length === 0 ? (
        <div className="empty-state">
          <p>{searchTerm ? 'Nenhum aluno encontrado.' : 'Nenhum aluno vinculado ainda.'}</p>
        </div>
      ) : (
        <div className="students-table-container">
          <table className="students-table">
            <thead>
              <tr>
                <th>Aluno</th>
                <th>Progresso</th>
                <th>Média Quiz</th>
                <th>Aulas</th>
                <th>Status</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              {filteredStudents.map(student => {
                const stats = getStudentStats(student.id)
                const progressPct = stats.total > 0
                  ? Math.round((stats.completed / stats.total) * 100)
                  : 0
                return (
                  <tr key={student.id}>
                    <td>
                      <div className="student-cell">
                        <span className="student-avatar-sm">
                          {(student.full_name || student.email || '?')[0].toUpperCase()}
                        </span>
                        <div>
                          <span className="student-name">{student.full_name || student.email}</span>
                          <span className="student-email">{student.email}</span>
                        </div>
                      </div>
                    </td>
                    <td>
                      <div className="progress-cell">
                        <div className="progress-bar-mini">
                          <div className="progress-fill-mini" style={{ width: `${progressPct}%` }} />
                        </div>
                        <span className="progress-text">{stats.completed}/{stats.total}</span>
                      </div>
                    </td>
                    <td>
                      <span className={`score-badge ${stats.avgScore !== null ? (stats.avgScore >= 70 ? 'good' : 'warning') : ''}`}>
                        {stats.avgScore !== null ? `${stats.avgScore}%` : '—'}
                      </span>
                    </td>
                    <td>{stats.lessonsCompleted}</td>
                    <td>
                      {stats.completed === stats.total && stats.total > 0 ? (
                        <span className="status-badge completed">Concluído</span>
                      ) : stats.inProgress > 0 ? (
                        <span className="status-badge in-progress">Em andamento</span>
                      ) : (
                        <span className="status-badge not-started">Não iniciado</span>
                      )}
                    </td>
                    <td>
                      <Link to={`/monitor/alunos/${student.id}`} className="btn-detail">
                        <FiChevronRight />
                      </Link>
                    </td>
                  </tr>
                )
              })}
            </tbody>
          </table>
        </div>
      )}
    </div>
  )
}
