import { useEffect, useState } from 'react'
import { useParams, Link } from 'react-router-dom'
import { supabase } from '../lib/supabase'
import { FiPlay, FiFileText, FiCheckCircle } from 'react-icons/fi'
import './DisciplineDetail.css'

export default function DisciplineDetail() {
  const { id } = useParams()
  const [discipline, setDiscipline] = useState(null)
  const [lessons, setLessons] = useState([])
  const [materials, setMaterials] = useState([])
  const [activeTab, setActiveTab] = useState('aulas')
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetchData()
  }, [id])

  const fetchData = async () => {
    const [discRes, lessonsRes, materialsRes] = await Promise.all([
      supabase.from('disciplines').select('*').eq('id', id).single(),
      supabase.from('lessons').select('*').eq('discipline_id', id).order('order_index'),
      supabase.from('materials').select('*').eq('discipline_id', id).order('created_at')
    ])

    if (discRes.data) setDiscipline(discRes.data)
    if (lessonsRes.data) setLessons(lessonsRes.data)
    if (materialsRes.data) setMaterials(materialsRes.data)
    setLoading(false)
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

      <div className="tabs">
        <button
          className={`tab ${activeTab === 'aulas' ? 'active' : ''}`}
          onClick={() => setActiveTab('aulas')}
        >
          <FiPlay /> Aulas ({lessons.length})
        </button>
        <button
          className={`tab ${activeTab === 'materiais' ? 'active' : ''}`}
          onClick={() => setActiveTab('materiais')}
        >
          <FiFileText /> Materiais ({materials.length})
        </button>
        <Link to={`/disciplinas/${id}/quiz`} className="tab tab-quiz">
          <FiCheckCircle /> Quiz
        </Link>
      </div>

      {activeTab === 'aulas' && (
        <div className="lessons-list">
          {lessons.map((lesson, index) => (
            <div key={lesson.id} className="lesson-card">
              <div className="lesson-number">{index + 1}</div>
              <div className="lesson-info">
                <h3>{lesson.title}</h3>
                {lesson.description && <p>{lesson.description}</p>}
              </div>
              {lesson.video_url && (
                <a
                  href={lesson.video_url}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="btn-watch"
                >
                  <FiPlay /> Assistir
                </a>
              )}
            </div>
          ))}

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
