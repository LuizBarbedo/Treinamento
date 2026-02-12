import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { supabase } from '../../lib/supabase'
import { useAuth } from '../../contexts/AuthContext'
import { FiFilter, FiSearch, FiMessageCircle } from 'react-icons/fi'
import './MonitorDoubts.css'

export default function MonitorDoubts() {
  const { user } = useAuth()
  const [loading, setLoading] = useState(true)
  const [doubts, setDoubts] = useState([])
  const [students, setStudents] = useState([])
  const [filter, setFilter] = useState('all') // 'all', 'open', 'answered', 'resolved'
  const [searchTerm, setSearchTerm] = useState('')

  useEffect(() => {
    if (user) fetchData()
  }, [user])

  const fetchData = async () => {
    try {
      const [studentsRes, doubtsRes] = await Promise.all([
        supabase.rpc('get_monitor_students', { p_monitor_id: user.id }),
        // Buscar todas as dúvidas dos alunos vinculados
        supabase.rpc('get_monitor_students', { p_monitor_id: user.id }).then(async ({ data }) => {
          if (!data || data.length === 0) return { data: [] }
          const studentIds = data.map(s => s.id)
          return supabase
            .from('doubts')
            .select('*, disciplines(name), lessons(title)')
            .in('user_id', studentIds)
            .order('created_at', { ascending: false })
        })
      ])

      setStudents(studentsRes.data || [])
      setDoubts(doubtsRes.data || [])
    } catch (err) {
      console.error('Erro ao buscar dúvidas:', err)
    } finally {
      setLoading(false)
    }
  }

  const getStudentName = (userId) => {
    const student = students.find(s => s.id === userId)
    return student?.full_name || student?.email || 'Aluno'
  }

  const getStatusLabel = (status) => {
    switch (status) {
      case 'open': return 'Aberta'
      case 'answered': return 'Respondida'
      case 'resolved': return 'Resolvida'
      default: return status
    }
  }

  const filteredDoubts = doubts.filter(d => {
    if (filter !== 'all' && d.status !== filter) return false
    if (searchTerm) {
      const term = searchTerm.toLowerCase()
      const studentName = getStudentName(d.user_id).toLowerCase()
      return d.title.toLowerCase().includes(term) ||
             d.description?.toLowerCase().includes(term) ||
             studentName.includes(term)
    }
    return true
  })

  const counts = {
    all: doubts.length,
    open: doubts.filter(d => d.status === 'open').length,
    answered: doubts.filter(d => d.status === 'answered').length,
    resolved: doubts.filter(d => d.status === 'resolved').length,
  }

  if (loading) {
    return (
      <div className="monitor-doubts-page">
        <div className="loading-screen">
          <div className="spinner"></div>
          <p>Carregando dúvidas...</p>
        </div>
      </div>
    )
  }

  return (
    <div className="monitor-doubts-page">
      <div className="page-header">
        <h1>💬 Dúvidas dos Alunos</h1>
        <p>{counts.open} pendente{counts.open !== 1 ? 's' : ''} de resposta</p>
      </div>

      {/* Filtros */}
      <div className="doubts-toolbar">
        <div className="doubts-filters">
          <button
            className={`filter-btn ${filter === 'all' ? 'active' : ''}`}
            onClick={() => setFilter('all')}
          >
            Todas ({counts.all})
          </button>
          <button
            className={`filter-btn ${filter === 'open' ? 'active' : ''}`}
            onClick={() => setFilter('open')}
          >
            Abertas ({counts.open})
          </button>
          <button
            className={`filter-btn ${filter === 'answered' ? 'active' : ''}`}
            onClick={() => setFilter('answered')}
          >
            Respondidas ({counts.answered})
          </button>
          <button
            className={`filter-btn ${filter === 'resolved' ? 'active' : ''}`}
            onClick={() => setFilter('resolved')}
          >
            Resolvidas ({counts.resolved})
          </button>
        </div>
        <div className="search-bar">
          <FiSearch />
          <input
            type="text"
            placeholder="Buscar dúvida..."
            value={searchTerm}
            onChange={e => setSearchTerm(e.target.value)}
          />
        </div>
      </div>

      {/* Lista de dúvidas */}
      {filteredDoubts.length === 0 ? (
        <div className="empty-state">
          <FiMessageCircle size={32} />
          <p>{searchTerm || filter !== 'all' ? 'Nenhuma dúvida encontrada com esse filtro.' : 'Nenhuma dúvida registrada ainda.'}</p>
        </div>
      ) : (
        <div className="doubts-list">
          {filteredDoubts.map(doubt => (
            <Link
              key={doubt.id}
              to={`/monitor/duvidas/${doubt.id}`}
              className="doubt-card-full"
            >
              <div className="doubt-card-top">
                <span className={`doubt-status status-${doubt.status}`}>
                  {getStatusLabel(doubt.status)}
                </span>
                <span className="doubt-date">
                  {new Date(doubt.created_at).toLocaleDateString('pt-BR', {
                    day: '2-digit', month: '2-digit', year: 'numeric',
                    hour: '2-digit', minute: '2-digit'
                  })}
                </span>
              </div>
              <h3 className="doubt-card-title">{doubt.title}</h3>
              <p className="doubt-card-desc">{doubt.description?.substring(0, 200)}</p>
              <div className="doubt-card-footer">
                <span className="doubt-student">{getStudentName(doubt.user_id)}</span>
                <span className="doubt-discipline">{doubt.disciplines?.name}</span>
                {doubt.lessons?.title && (
                  <span className="doubt-lesson">{doubt.lessons.title}</span>
                )}
              </div>
            </Link>
          ))}
        </div>
      )}
    </div>
  )
}
