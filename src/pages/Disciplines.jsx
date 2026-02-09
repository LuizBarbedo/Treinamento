import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'
import { FiLock, FiCheck } from 'react-icons/fi'
import './Disciplines.css'

export default function Disciplines() {
  const { user } = useAuth()
  const [disciplines, setDisciplines] = useState([])
  const [completedDisciplines, setCompletedDisciplines] = useState(new Set())
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetchDisciplines()
  }, [])

  const fetchDisciplines = async () => {
    const [discRes, progressRes] = await Promise.all([
      supabase.from('disciplines').select('*').order('order_index'),
      supabase.from('user_progress').select('discipline_id').eq('user_id', user.id).eq('completed', true)
    ])

    if (discRes.data) setDisciplines(discRes.data)
    if (progressRes.data) {
      setCompletedDisciplines(new Set(progressRes.data.map(p => p.discipline_id)))
    }
    setLoading(false)
  }

  const isDisciplineAccessible = (index) => {
    if (index === 0) return true
    return completedDisciplines.has(disciplines[index - 1].id)
  }

  if (loading) {
    return <div className="loading-screen"><div className="spinner"></div></div>
  }

  return (
    <div className="disciplines-page">
      <h1>📚 Disciplinas</h1>
      <p className="page-subtitle">Complete cada disciplina em ordem para avançar</p>

      <div className="disciplines-list">
        {disciplines.map((disc, index) => {
          const accessible = isDisciplineAccessible(index)
          const isCompleted = completedDisciplines.has(disc.id)

          if (!accessible) {
            return (
              <div key={disc.id} className="discipline-item discipline-locked">
                <div className="disc-icon">{disc.icon || '📖'}</div>
                <div className="disc-info">
                  <h3>{disc.name}</h3>
                  <p>{disc.description}</p>
                  <span className="disc-locked-msg"><FiLock /> Complete a disciplina anterior para desbloquear</span>
                </div>
                <div className="disc-arrow disc-arrow-locked"><FiLock /></div>
              </div>
            )
          }

          return (
            <Link key={disc.id} to={`/disciplinas/${disc.id}`} className={`discipline-item ${isCompleted ? 'discipline-completed' : ''}`}>
              <div className="disc-icon">{disc.icon || '📖'}</div>
              <div className="disc-info">
                <h3>{disc.name}</h3>
                <p>{disc.description}</p>
                {isCompleted && <span className="disc-completed-badge"><FiCheck /> Concluída</span>}
              </div>
              <div className="disc-arrow">{isCompleted ? <FiCheck /> : '→'}</div>
            </Link>
          )
        })}

        {disciplines.length === 0 && (
          <div className="empty-state">
            <p>Nenhuma disciplina cadastrada.</p>
          </div>
        )}
      </div>
    </div>
  )
}
