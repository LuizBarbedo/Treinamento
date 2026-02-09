import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'
import { FiBook, FiAward, FiTrendingUp, FiLock, FiCheck } from 'react-icons/fi'
import './Dashboard.css'

export default function Dashboard() {
  const { user } = useAuth()
  const [stats, setStats] = useState({ total: 0, completed: 0, inProgress: 0 })
  const [disciplines, setDisciplines] = useState([])
  const [completedDisciplines, setCompletedDisciplines] = useState(new Set())

  useEffect(() => {
    fetchData()
  }, [])

  const fetchData = async () => {
    // Buscar todas as disciplinas
    const { data: allDiscs } = await supabase
      .from('disciplines')
      .select('*')
      .order('order_index')

    if (allDiscs) setDisciplines(allDiscs)

    // Buscar disciplinas concluídas (quiz final aprovado)
    const { data: completedProgress } = await supabase
      .from('user_progress')
      .select('discipline_id')
      .eq('user_id', user.id)
      .eq('completed', true)

    const completedIds = new Set((completedProgress || []).map(p => p.discipline_id))
    setCompletedDisciplines(completedIds)

    // Buscar aulas com progresso (para detectar "em andamento")
    const { data: lessonProgress } = await supabase
      .from('lesson_progress')
      .select('discipline_id')
      .eq('user_id', user.id)

    // Disciplinas em andamento = tem pelo menos 1 aula concluída mas disciplina não está completa
    const inProgressIds = new Set()
    if (lessonProgress) {
      lessonProgress.forEach(lp => {
        if (!completedIds.has(lp.discipline_id)) {
          inProgressIds.add(lp.discipline_id)
        }
      })
    }

    setStats({
      total: allDiscs?.length || 0,
      completed: completedIds.size,
      inProgress: inProgressIds.size
    })
  }

  const displayName = user?.user_metadata?.full_name || user?.email?.split('@')[0] || 'Usuário'

  const isDisciplineAccessible = (index) => {
    if (index === 0) return true
    return completedDisciplines.has(disciplines[index - 1].id)
  }

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
          {disciplines.slice(0, 4).map((disc, index) => {
            const accessible = isDisciplineAccessible(index)
            const isCompleted = completedDisciplines.has(disc.id)

            if (!accessible) {
              return (
                <div key={disc.id} className="discipline-card discipline-card-locked">
                  <div className="discipline-emoji">{disc.icon || '📚'}</div>
                  <h3>{disc.name}</h3>
                  <p>{disc.description}</p>
                  <span className="card-locked-badge"><FiLock /> Bloqueada</span>
                </div>
              )
            }

            return (
              <Link key={disc.id} to={`/disciplinas/${disc.id}`} className={`discipline-card ${isCompleted ? 'discipline-card-completed' : ''}`}>
                <div className="discipline-emoji">{disc.icon || '📚'}</div>
                <h3>{disc.name}</h3>
                <p>{disc.description}</p>
                {isCompleted && <span className="card-completed-badge"><FiCheck /> Concluída</span>}
              </Link>
            )
          })}

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
