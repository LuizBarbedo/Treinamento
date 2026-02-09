import { useEffect, useState } from 'react'
import { useParams, Link } from 'react-router-dom'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'
import { FiPlay, FiFileText, FiCheckCircle, FiLock, FiCheck, FiX } from 'react-icons/fi'
import AIChat from '../components/AIChat'
import './DisciplineDetail.css'

function getEmbedUrl(url) {
  if (!url) return null
  // YouTube: youtube.com/watch?v=ID or youtu.be/ID
  let match = url.match(/(?:youtube\.com\/watch\?v=|youtu\.be\/)([\w-]+)/)
  if (match) return `https://www.youtube.com/embed/${match[1]}?rel=0`
  // YouTube embed already
  if (url.includes('youtube.com/embed/')) return url
  // Vimeo: vimeo.com/ID
  match = url.match(/vimeo\.com\/(\d+)/)
  if (match) return `https://player.vimeo.com/video/${match[1]}`
  // Google Drive: drive.google.com/file/d/ID
  match = url.match(/drive\.google\.com\/file\/d\/([\w-]+)/)
  if (match) return `https://drive.google.com/file/d/${match[1]}/preview`
  // Fallback: try embedding directly
  return url
}

export default function DisciplineDetail() {
  const { id } = useParams()
  const { user } = useAuth()
  const [discipline, setDiscipline] = useState(null)
  const [lessons, setLessons] = useState([])
  const [materials, setMaterials] = useState([])
  const [completedLessons, setCompletedLessons] = useState(new Set())
  const [activeTab, setActiveTab] = useState('aulas')
  const [activeLesson, setActiveLesson] = useState(null)
  const [loading, setLoading] = useState(true)

  const totalContent = lessons.length + materials.length
  const completedCount = completedLessons.size
  const allLessonsCompleted = lessons.length > 0 && completedLessons.size >= lessons.length
  const allContentCompleted = totalContent > 0 && completedCount >= totalContent
  const progressPercent = totalContent > 0 ? Math.round((completedCount / totalContent) * 100) : 0

  useEffect(() => {
    fetchData()
  }, [id])

  const fetchData = async () => {
    const [discRes, lessonsRes, materialsRes, progressRes] = await Promise.all([
      supabase.from('disciplines').select('*').eq('id', id).single(),
      supabase.from('lessons').select('*').eq('discipline_id', id).order('order_index'),
      supabase.from('materials').select('*').eq('discipline_id', id).order('created_at'),
      supabase.from('lesson_progress').select('lesson_id').eq('user_id', user.id).eq('discipline_id', id)
    ])

    if (discRes.data) setDiscipline(discRes.data)
    if (lessonsRes.data) setLessons(lessonsRes.data)
    if (materialsRes.data) setMaterials(materialsRes.data)
    if (progressRes.data) {
      setCompletedLessons(new Set(progressRes.data.map(p => p.lesson_id)))
    }
    setLoading(false)
  }

  const toggleLessonComplete = async (lessonId) => {
    const isCompleted = completedLessons.has(lessonId)

    if (isCompleted) {
      // Desmarcar
      await supabase
        .from('lesson_progress')
        .delete()
        .eq('user_id', user.id)
        .eq('lesson_id', lessonId)

      setCompletedLessons(prev => {
        const next = new Set(prev)
        next.delete(lessonId)
        return next
      })
    } else {
      // Marcar como concluída
      await supabase.from('lesson_progress').insert({
        user_id: user.id,
        lesson_id: lessonId,
        discipline_id: id
      })

      setCompletedLessons(prev => new Set([...prev, lessonId]))
    }
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

      {/* Barra de Progresso */}
      {totalContent > 0 && (
        <div className="progress-section">
          <div className="progress-header">
            <span className="progress-label">Progresso do Conteúdo</span>
            <span className="progress-value">{completedCount}/{totalContent} concluídos ({progressPercent}%)</span>
          </div>
          <div className="progress-bar">
            <div className="progress-fill" style={{ width: `${progressPercent}%` }} />
          </div>
          {allContentCompleted && (
            <p className="progress-complete-msg">✅ Todo o conteúdo foi concluído! O quiz está liberado.</p>
          )}
        </div>
      )}

      <div className="tabs">
        <button
          className={`tab ${activeTab === 'aulas' ? 'active' : ''}`}
          onClick={() => setActiveTab('aulas')}
        >
          <FiPlay /> Aulas ({completedLessons.size}/{lessons.length})
        </button>
        <button
          className={`tab ${activeTab === 'materiais' ? 'active' : ''}`}
          onClick={() => setActiveTab('materiais')}
        >
          <FiFileText /> Materiais ({materials.length})
        </button>

        {allContentCompleted ? (
          <Link to={`/disciplinas/${id}/quiz`} className="tab tab-quiz tab-quiz-unlocked">
            <FiCheckCircle /> Fazer Quiz
          </Link>
        ) : (
          <span className="tab tab-quiz tab-quiz-locked" title="Conclua todo o conteúdo para liberar o quiz">
            <FiLock /> Quiz (bloqueado)
          </span>
        )}
      </div>

      {activeTab === 'aulas' && (
        <div className="lessons-list">
          {lessons.map((lesson, index) => {
            const isCompleted = completedLessons.has(lesson.id)
            return (
              <div key={lesson.id} className="lesson-wrapper">
                <div className={`lesson-card ${isCompleted ? 'completed' : ''} ${activeLesson?.id === lesson.id ? 'playing' : ''}`}>
                  <button
                    className={`lesson-check ${isCompleted ? 'checked' : ''}`}
                    onClick={() => toggleLessonComplete(lesson.id)}
                    title={isCompleted ? 'Desmarcar aula' : 'Marcar como concluída'}
                  >
                    {isCompleted ? <FiCheck /> : <span className="lesson-number-text">{index + 1}</span>}
                  </button>
                  <div className="lesson-info">
                    <h3 className={isCompleted ? 'lesson-done' : ''}>{lesson.title}</h3>
                    {lesson.description && <p>{lesson.description}</p>}
                  </div>
                  {lesson.video_url && (
                    <button
                      className={`btn-watch ${activeLesson?.id === lesson.id ? 'btn-watch-active' : ''}`}
                      onClick={() => setActiveLesson(activeLesson?.id === lesson.id ? null : lesson)}
                    >
                      {activeLesson?.id === lesson.id ? <><FiX /> Fechar</> : <><FiPlay /> Assistir</>}
                    </button>
                  )}
                </div>
                {activeLesson?.id === lesson.id && (
                  <div className="video-player-inline">
                    <div className="video-wrapper">
                      <iframe
                        src={getEmbedUrl(lesson.video_url)}
                        title={lesson.title}
                        frameBorder="0"
                        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                        allowFullScreen
                      />
                    </div>
                  </div>
                )}
              </div>
            )
          })}

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

      <AIChat discipline={discipline} lessons={lessons} materials={materials} />
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
