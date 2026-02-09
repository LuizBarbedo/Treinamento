import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { supabase } from '../lib/supabase'
import './Disciplines.css'

export default function Disciplines() {
  const [disciplines, setDisciplines] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetchDisciplines()
  }, [])

  const fetchDisciplines = async () => {
    const { data } = await supabase
      .from('disciplines')
      .select('*')
      .order('order_index')

    if (data) setDisciplines(data)
    setLoading(false)
  }

  if (loading) {
    return <div className="loading-screen"><div className="spinner"></div></div>
  }

  return (
    <div className="disciplines-page">
      <h1>📚 Disciplinas</h1>
      <p className="page-subtitle">Escolha uma disciplina para começar a estudar</p>

      <div className="disciplines-list">
        {disciplines.map((disc) => (
          <Link key={disc.id} to={`/disciplinas/${disc.id}`} className="discipline-item">
            <div className="disc-icon">{disc.icon || '📖'}</div>
            <div className="disc-info">
              <h3>{disc.name}</h3>
              <p>{disc.description}</p>
            </div>
            <div className="disc-arrow">→</div>
          </Link>
        ))}

        {disciplines.length === 0 && (
          <div className="empty-state">
            <p>Nenhuma disciplina cadastrada.</p>
          </div>
        )}
      </div>
    </div>
  )
}
