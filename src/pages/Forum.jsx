import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'
import { FiPlus, FiMessageSquare, FiSearch, FiThumbsUp, FiMapPin } from 'react-icons/fi'
import './Forum.css'

const CATEGORIES = [
  { value: 'all', label: 'Todos' },
  { value: 'pergunta', label: '❓ Pergunta' },
  { value: 'discussao', label: '💬 Discussão' },
  { value: 'insight', label: '💡 Insight' },
]

export default function Forum() {
  const { user } = useAuth()
  const [loading, setLoading] = useState(true)
  const [posts, setPosts] = useState([])
  const [disciplines, setDisciplines] = useState([])
  const [lessons, setLessons] = useState([])
  const [categoryFilter, setCategoryFilter] = useState('all')
  const [disciplineFilter, setDisciplineFilter] = useState('all')
  const [searchTerm, setSearchTerm] = useState('')
  const [showForm, setShowForm] = useState(false)
  const [submitting, setSubmitting] = useState(false)
  const [formData, setFormData] = useState({
    title: '',
    content: '',
    category: 'discussao',
    discipline_id: '',
    lesson_id: '',
  })

  useEffect(() => {
    fetchData()
  }, [categoryFilter, disciplineFilter])

  const fetchData = async () => {
    try {
      // Buscar disciplinas
      const { data: discData } = await supabase
        .from('disciplines')
        .select('*')
        .order('order_index')
      setDisciplines(discData || [])

      // Buscar posts com contagens
      let query = supabase
        .from('forum_posts')
        .select(`
          *,
          disciplines(name, icon),
          lessons(title),
          forum_replies(count),
          forum_post_likes(count)
        `)
        .order('is_pinned', { ascending: false })
        .order('created_at', { ascending: false })

      if (categoryFilter !== 'all') {
        query = query.eq('category', categoryFilter)
      }
      if (disciplineFilter !== 'all') {
        query = query.eq('discipline_id', disciplineFilter)
      }

      const { data: postsData } = await query

      // Buscar nomes dos autores
      if (postsData && postsData.length > 0) {
        const userIds = [...new Set(postsData.map(p => p.user_id))]
        const { data: profiles } = await supabase
          .from('user_roles')
          .select('user_id, role')
          .in('user_id', userIds)

        const rolesMap = {}
        profiles?.forEach(p => { rolesMap[p.user_id] = p.role })

        // Buscar nomes via auth (metadata)
        const { data: userNames } = await supabase.rpc('get_user_names', {
          p_user_ids: userIds
        })
        const namesMap = {}
        userNames?.forEach(u => { namesMap[u.user_id] = u.full_name })

        const enriched = postsData.map(post => ({
          ...post,
          author_name: namesMap[post.user_id] || 'Usuário',
          author_role: rolesMap[post.user_id] || 'user',
          reply_count: post.forum_replies?.[0]?.count || 0,
          like_count: post.forum_post_likes?.[0]?.count || 0,
        }))
        setPosts(enriched)
      } else {
        setPosts([])
      }
    } catch (err) {
      console.error('Erro ao buscar posts:', err)
    } finally {
      setLoading(false)
    }
  }

  const handleDisciplineFormChange = async (discId) => {
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
    if (!formData.title.trim() || !formData.content.trim()) return
    setSubmitting(true)

    try {
      const insertData = {
        user_id: user.id,
        title: formData.title.trim(),
        content: formData.content.trim(),
        category: formData.category,
        discipline_id: formData.discipline_id || null,
        lesson_id: formData.lesson_id || null,
      }

      const { error } = await supabase.from('forum_posts').insert(insertData)
      if (error) throw error

      setFormData({ title: '', content: '', category: 'discussao', discipline_id: '', lesson_id: '' })
      setShowForm(false)
      setLessons([])
      fetchData()
    } catch (err) {
      console.error('Erro ao criar post:', err)
      alert('Erro ao criar post. Tente novamente.')
    } finally {
      setSubmitting(false)
    }
  }

  const filteredPosts = posts.filter(post => {
    if (!searchTerm) return true
    const term = searchTerm.toLowerCase()
    return (
      post.title.toLowerCase().includes(term) ||
      post.content.toLowerCase().includes(term)
    )
  })

  const formatDate = (dateStr) => {
    const date = new Date(dateStr)
    const now = new Date()
    const diffMs = now - date
    const diffMin = Math.floor(diffMs / 60000)
    const diffH = Math.floor(diffMin / 60)
    const diffD = Math.floor(diffH / 24)

    if (diffMin < 1) return 'agora'
    if (diffMin < 60) return `${diffMin}min atrás`
    if (diffH < 24) return `${diffH}h atrás`
    if (diffD < 7) return `${diffD}d atrás`
    return date.toLocaleDateString('pt-BR')
  }

  const getAuthorInitials = (post) => {
    const name = post.author_name || ''
    if (name.includes(' ')) {
      const parts = name.split(' ')
      return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase()
    }
    return (name || '??').substring(0, 2).toUpperCase()
  }

  const getCategoryLabel = (cat) => {
    const map = { pergunta: '❓ Pergunta', discussao: '💬 Discussão', insight: '💡 Insight' }
    return map[cat] || cat
  }

  if (loading) {
    return <div className="forum-page"><div className="forum-loading">Carregando fórum...</div></div>
  }

  return (
    <div className="forum-page">
      <div className="page-header">
        <div>
          <h1>💬 Fórum</h1>
          <p>Discuta, pergunte e compartilhe insights sobre as disciplinas</p>
        </div>
        <button className="btn-new-post" onClick={() => setShowForm(!showForm)}>
          <FiPlus /> Novo Post
        </button>
      </div>

      {/* New Post Form */}
      {showForm && (
        <div className="post-form-card">
          <h3>Criar novo post</h3>
          <form onSubmit={handleSubmit}>
            <div className="form-group">
              <label>Título *</label>
              <input
                type="text"
                placeholder="Título do seu post..."
                value={formData.title}
                onChange={e => setFormData(prev => ({ ...prev, title: e.target.value }))}
                maxLength={200}
                required
              />
            </div>

            <div className="form-row">
              <div className="form-group">
                <label>Categoria</label>
                <select
                  value={formData.category}
                  onChange={e => setFormData(prev => ({ ...prev, category: e.target.value }))}
                >
                  <option value="discussao">💬 Discussão</option>
                  <option value="pergunta">❓ Pergunta</option>
                  <option value="insight">💡 Insight</option>
                </select>
              </div>
              <div className="form-group">
                <label>Disciplina (opcional)</label>
                <select
                  value={formData.discipline_id}
                  onChange={e => handleDisciplineFormChange(e.target.value)}
                >
                  <option value="">Geral</option>
                  {disciplines.map(d => (
                    <option key={d.id} value={d.id}>{d.icon} {d.name}</option>
                  ))}
                </select>
              </div>
            </div>

            {formData.discipline_id && lessons.length > 0 && (
              <div className="form-group">
                <label>Aula (opcional)</label>
                <select
                  value={formData.lesson_id}
                  onChange={e => setFormData(prev => ({ ...prev, lesson_id: e.target.value }))}
                >
                  <option value="">Nenhuma aula específica</option>
                  {lessons.map(l => (
                    <option key={l.id} value={l.id}>{l.title}</option>
                  ))}
                </select>
              </div>
            )}

            <div className="form-group">
              <label>Conteúdo *</label>
              <textarea
                placeholder="Escreva seu post aqui..."
                value={formData.content}
                onChange={e => setFormData(prev => ({ ...prev, content: e.target.value }))}
                rows={5}
                required
              />
            </div>

            <div className="form-actions">
              <button type="button" className="btn-cancel-post" onClick={() => setShowForm(false)}>
                Cancelar
              </button>
              <button type="submit" className="btn-submit-post" disabled={submitting}>
                {submitting ? 'Publicando...' : 'Publicar'}
              </button>
            </div>
          </form>
        </div>
      )}

      {/* Filters */}
      <div className="forum-filters">
        <select value={disciplineFilter} onChange={e => setDisciplineFilter(e.target.value)}>
          <option value="all">Todas as disciplinas</option>
          {disciplines.map(d => (
            <option key={d.id} value={d.id}>{d.icon} {d.name}</option>
          ))}
        </select>
        <input
          className="search-input"
          type="text"
          placeholder="Buscar posts..."
          value={searchTerm}
          onChange={e => setSearchTerm(e.target.value)}
        />
      </div>

      {/* Category Tabs */}
      <div className="category-tabs">
        {CATEGORIES.map(cat => (
          <button
            key={cat.value}
            className={`category-tab ${categoryFilter === cat.value ? 'active' : ''}`}
            onClick={() => setCategoryFilter(cat.value)}
          >
            {cat.label}
          </button>
        ))}
      </div>

      {/* Posts List */}
      {filteredPosts.length === 0 ? (
        <div className="forum-empty">
          <FiMessageSquare />
          <h3>Nenhum post encontrado</h3>
          <p>Seja o primeiro a iniciar uma discussão!</p>
        </div>
      ) : (
        <div className="forum-posts-list">
          {filteredPosts.map(post => (
            <Link
              key={post.id}
              to={`/forum/${post.id}`}
              className={`forum-post-card ${post.is_pinned ? 'pinned' : ''}`}
            >
              <div className="post-card-header">
                <span className={`post-category-badge ${post.category}`}>
                  {getCategoryLabel(post.category)}
                </span>
                {post.is_pinned && (
                  <span className="post-pin-badge"><FiMapPin /> Fixado</span>
                )}
                {post.disciplines && (
                  <span className="post-discipline-tag">
                    {post.disciplines.icon} {post.disciplines.name}
                  </span>
                )}
                {post.lessons && (
                  <span className="post-discipline-tag">
                    📖 {post.lessons.title}
                  </span>
                )}
              </div>

              <div className="post-card-title">{post.title}</div>
              <div className="post-card-preview">{post.content}</div>

              <div className="post-card-footer">
                <div className="post-card-author">
                  <span className={`post-author-avatar ${post.author_role === 'monitor' ? 'monitor' : ''}`}>
                    {getAuthorInitials(post)}
                  </span>
                  <span className="post-author-name">{post.author_name || 'Usuário'}</span>
                  <span>• {formatDate(post.created_at)}</span>
                  {post.author_role === 'monitor' && (
                    <span className="post-author-role monitor">Monitor</span>
                  )}
                </div>
                <div className="post-card-stats">
                  <span><FiThumbsUp /> {post.like_count}</span>
                  <span><FiMessageSquare /> {post.reply_count}</span>
                </div>
              </div>
            </Link>
          ))}
        </div>
      )}
    </div>
  )
}
