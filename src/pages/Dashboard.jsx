import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'
import { FiBook, FiAward, FiTrendingUp } from 'react-icons/fi'
import './Dashboard.css'

export default function Dashboard() {
  const { user } = useAuth()
  const [stats, setStats] = useState({ total: 0, completed: 0, inProgress: 0 })
  const [disciplines, setDisciplines] = useState([])

  useEffect(() => {
    fetchData()
  }, [])

  const fetchData = async () => {
    // Buscar disciplinas
    const { data: discs } = await supabase
      .from('disciplines')
      .select('*')
      .order('order_index')
      .limit(4)

    if (discs) setDisciplines(discs)

    // Buscar progresso do aluno
    const { data: progress } = await supabase
      .from('user_progress')
      .select('*')
      .eq('user_id', user.id)

    if (progress) {
      const completed = progress.filter(p => p.completed).length
      setStats({
        total: discs?.length || 0,
        completed,
        inProgress: progress.filter(p => !p.completed).length
      })
    }
  }

  const displayName = user?.user_metadata?.full_name || user?.email?.split('@')[0] || 'Usuário'

  return (
    <div className="dashboard">
      <div className="dashboard-welcome">
        <h1>Olá, {displayName}! 👋</h1>
        <p>Bem-vindo à plataforma de treinamento. Continue seus estudos de onde parou.</p>
      </div>

      <div className="stats-grid">
        <div className="stat-card">
          <FiBook className="stat-icon" />
          <div>
            <span className="stat-number">{stats.total}</span>
            <span className="stat-label">Disciplinas</span>
          </div>
        </div>
        <div className="stat-card">
          <FiTrendingUp className="stat-icon" />
          <div>
            <span className="stat-number">{stats.inProgress}</span>
            <span className="stat-label">Em Andamento</span>
          </div>
        </div>
        <div className="stat-card">
          <FiAward className="stat-icon" />
          <div>
            <span className="stat-number">{stats.completed}</span>
            <span className="stat-label">Concluídas</span>
          </div>
        </div>
      </div>

      <div className="section">
        <div className="section-header">
          <h2>Disciplinas Disponíveis</h2>
          <Link to="/disciplinas" className="btn-see-all">Ver todas →</Link>
        </div>

        <div className="disciplines-grid">
          {disciplines.map((disc) => (
            <Link key={disc.id} to={`/disciplinas/${disc.id}`} className="discipline-card">
              <div className="discipline-emoji">{disc.icon || '📚'}</div>
              <h3>{disc.name}</h3>
              <p>{disc.description}</p>
            </Link>
          ))}

          {disciplines.length === 0 && (
            <div className="empty-state">
              <p>Nenhuma disciplina disponível ainda.</p>
              <p className="empty-hint">As disciplinas serão adicionadas pelo administrador.</p>
            </div>
          )}
        </div>
      </div>
    </div>
  )
}
