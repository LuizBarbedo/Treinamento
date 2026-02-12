import { useEffect, useState } from 'react'
import { Link, useSearchParams } from 'react-router-dom'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'
import { FiPlus, FiMessageCircle, FiFilter } from 'react-icons/fi'
import './MyDoubts.css'

export default function MyDoubts() {
  const { user } = useAuth()
  const [searchParams] = useSearchParams()
  const [loading, setLoading] = useState(true)
  const [doubts, setDoubts] = useState([])
  const [disciplines, setDisciplines] = useState([])
  const [filter, setFilter] = useState('all')
  const [showForm, setShowForm] = useState(false)
  const [formData, setFormData] = useState({ discipline_id: '', lesson_id: '', title: '', description: '' })
  const [lessons, setLessons] = useState([])
  const [submitting, setSubmitting] = useState(false)
  const [monitor, setMonitor] = useState(null)

  useEffect(() => {
    if (user) fetchData()
  }, [user])

  const fetchData = async () => {
    try {
      const [doubtsRes, discRes, monitorRes] = await Promise.all([
        supabase
          .from('doubts')
          .select('*, disciplines(name), lessons(title)')
          .eq('user_id', user.id)
          .order('created_at', { ascending: false }),
        supabase.from('disciplines').select('*').order('order_index'),
        supabase.from('monitor_students').select('monitor_id').eq('student_id', user.id).single(),
      ])

      setDoubts(doubtsRes.data || [])
      setDisciplines(discRes.data || [])

      if (monitorRes.data) {
        setMonitor(monitorRes.data)
      }

      // Se veio de uma disciplina (via query param), abrir form automaticamente
      const discParam = searchParams.get('disciplina')
      if (discParam && monitorRes.data) {
        setFormData(prev => ({ ...prev, discipline_id: discParam }))
        setShowForm(true)
        // Buscar aulas da disciplina
        const { data: discLessons } = await supabase
          .from('lessons')
          .select('*')
          .eq('discipline_id', discParam)
          .order('order_index')
        setLessons(discLessons || [])
      }
    } catch (err) {
      console.error('Erro ao buscar dúvidas:', err)
    } finally {
      setLoading(false)
    }
  }

  const handleDisciplineChange = async (discId) => {
    setFormData(prev => ({ ...prev, discipline_id: discId, lesson_id: '' }))
    if (discId) {
      const { data } = await supabase
        .from('lessons')
        .select('*')
        .eq('discipline_id', discId)
        .order('order_index')
      setLessons(data || [])
    } else {
      setLessons([])
    }
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    if (!formData.title.trim() || !formData.description.trim() || !formData.discipline_id) return

    setSubmitting(true)
    try {
      const { error } = await supabase.from('doubts').insert({
        user_id: user.id,
        discipline_id: formData.discipline_id,
        lesson_id: formData.lesson_id || null,
        title: formData.title.trim(),
        description: formData.description.trim(),
      })

      if (error) throw error

      setFormData({ discipline_id: '', lesson_id: '', title: '', description: '' })
      setShowForm(false)
      fetchData()
    } catch (err) {
      console.error('Erro ao criar dúvida:', err)
      alert('Erro ao criar dúvida. Tente novamente.')
    } finally {
      setSubmitting(false)
    }
  }

  const getStatusLabel = (status) => {
    switch (status) {
      case 'open': return 'Aguardando'
      case 'answered': return 'Respondida'
      case 'resolved': return 'Resolvida'
      default: return status
    }
  }

  const filteredDoubts = filter === 'all' ? doubts : doubts.filter(d => d.status === filter)

  if (loading) {
    return (
      <div className="my-doubts-page">
        <div className="loading-screen">
          <div className="spinner"></div>
          <p>Carregando dúvidas...</p>
        </div>
      </div>
    )
  }

  return (
    <div className="my-doubts-page">
      <div className="page-header">
        <div>
          <h1>💬 Minhas Dúvidas</h1>
          <p>Tire dúvidas com seu monitor sobre as disciplinas</p>
        </div>
        {monitor && (
          <button className="btn-new-doubt" onClick={() => setShowForm(!showForm)}>
            <FiPlus /> Nova Dúvida
          </button>
        )}
      </div>

      {!monitor && (
        <div className="no-monitor-notice">
          <FiMessageCircle size={28} />
          <p>Você ainda não tem um monitor vinculado.</p>
          <p className="hint">O administrador irá vincular um monitor ao seu perfil em breve.</p>
        </div>
      )}

      {/* Form de nova dúvida */}
      {showForm && monitor && (
        <div className="doubt-form-card">
          <h3>Nova Dúvida</h3>
          <form onSubmit={handleSubmit}>
            <div className="form-group">
              <label>Disciplina *</label>
              <select
                value={formData.discipline_id}
                onChange={e => handleDisciplineChange(e.target.value)}
                required
              >
                <option value="">Selecione a disciplina</option>
                {disciplines.map(d => (
                  <option key={d.id} value={d.id}>{d.icon} {d.name}</option>
                ))}
              </select>
            </div>

            {lessons.length > 0 && (
              <div className="form-group">
                <label>Aula (opcional)</label>
                <select
                  value={formData.lesson_id}
                  onChange={e => setFormData(prev => ({ ...prev, lesson_id: e.target.value }))}
                >
                  <option value="">Dúvida geral da disciplina</option>
                  {lessons.map(l => (
                    <option key={l.id} value={l.id}>{l.title}</option>
                  ))}
                </select>
              </div>
            )}

            <div className="form-group">
              <label>Título *</label>
              <input
                type="text"
                placeholder="Resumo da sua dúvida..."
                value={formData.title}
                onChange={e => setFormData(prev => ({ ...prev, title: e.target.value }))}
                required
                maxLength={200}
              />
            </div>

            <div className="form-group">
              <label>Descrição *</label>
              <textarea
                placeholder="Descreva sua dúvida em detalhes..."
                value={formData.description}
                onChange={e => setFormData(prev => ({ ...prev, description: e.target.value }))}
                required
                rows={4}
              />
            </div>

            <div className="form-actions">
              <button type="button" className="btn-cancel" onClick={() => setShowForm(false)}>
                Cancelar
              </button>
              <button type="submit" className="btn-submit" disabled={submitting}>
                {submitting ? 'Enviando...' : 'Enviar Dúvida'}
              </button>
            </div>
          </form>
        </div>
      )}

      {/* Filtros */}
      {doubts.length > 0 && (
        <div className="doubts-filter-bar">
          <button className={`filter-btn ${filter === 'all' ? 'active' : ''}`} onClick={() => setFilter('all')}>
            Todas ({doubts.length})
          </button>
          <button className={`filter-btn ${filter === 'open' ? 'active' : ''}`} onClick={() => setFilter('open')}>
            Aguardando ({doubts.filter(d => d.status === 'open').length})
          </button>
          <button className={`filter-btn ${filter === 'answered' ? 'active' : ''}`} onClick={() => setFilter('answered')}>
            Respondidas ({doubts.filter(d => d.status === 'answered').length})
          </button>
          <button className={`filter-btn ${filter === 'resolved' ? 'active' : ''}`} onClick={() => setFilter('resolved')}>
            Resolvidas ({doubts.filter(d => d.status === 'resolved').length})
          </button>
        </div>
      )}

      {/* Lista */}
      {filteredDoubts.length === 0 ? (
        <div className="empty-doubts">
          <FiMessageCircle size={32} />
          <p>{doubts.length === 0 ? 'Você ainda não enviou nenhuma dúvida.' : 'Nenhuma dúvida com esse filtro.'}</p>
          {monitor && doubts.length === 0 && (
            <button className="btn-new-doubt-alt" onClick={() => setShowForm(true)}>
              <FiPlus /> Criar primeira dúvida
            </button>
          )}
        </div>
      ) : (
        <div className="my-doubts-list">
          {filteredDoubts.map(doubt => (
            <Link key={doubt.id} to={`/minhas-duvidas/${doubt.id}`} className="my-doubt-card">
              <div className="my-doubt-top">
                <span className={`doubt-status status-${doubt.status}`}>
                  {getStatusLabel(doubt.status)}
                </span>
                <span className="doubt-date">
                  {new Date(doubt.created_at).toLocaleDateString('pt-BR')}
                </span>
              </div>
              <h3>{doubt.title}</h3>
              <p className="doubt-preview">{doubt.description?.substring(0, 150)}</p>
              <div className="doubt-footer">
                <span className="doubt-disc-tag">{doubt.disciplines?.name}</span>
                {doubt.lessons?.title && (
                  <span className="doubt-lesson-tag">{doubt.lessons.title}</span>
                )}
              </div>
            </Link>
          ))}
        </div>
      )}
    </div>
  )
}
