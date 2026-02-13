import { useEffect, useState } from 'react'
import { Link, useParams, useNavigate } from 'react-router-dom'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'
import {
  FiArrowLeft,
  FiThumbsUp,
  FiMessageSquare,
  FiTrash2,
  FiCheckCircle,
  FiMapPin,
} from 'react-icons/fi'
import './ForumPost.css'

export default function ForumPost() {
  const { postId } = useParams()
  const navigate = useNavigate()
  const { user, isAdmin, isMonitor } = useAuth()

  const [loading, setLoading] = useState(true)
  const [post, setPost] = useState(null)
  const [replies, setReplies] = useState([])
  const [replyContent, setReplyContent] = useState('')
  const [submitting, setSubmitting] = useState(false)
  const [liked, setLiked] = useState(false)
  const [likeCount, setLikeCount] = useState(0)
  const [replyLikes, setReplyLikes] = useState({}) // { reply_id: { liked, count } }

  useEffect(() => {
    if (postId) fetchPost()
  }, [postId])

  const fetchPost = async () => {
    try {
      // Buscar post
      const { data: postData, error: postErr } = await supabase
        .from('forum_posts')
        .select(`
          *,
          disciplines(name, icon),
          lessons(title)
        `)
        .eq('id', postId)
        .single()

      if (postErr || !postData) {
        navigate('/forum')
        return
      }

      // Buscar role do autor do post
      const { data: authorRole } = await supabase
        .from('user_roles')
        .select('role')
        .eq('user_id', postData.user_id)
        .single()

      // Buscar nome do autor do post
      const { data: authorNames } = await supabase.rpc('get_user_names', {
        p_user_ids: [postData.user_id]
      })
      const authorName = authorNames?.[0]?.full_name || 'Usuário'

      setPost({ ...postData, author_role: authorRole?.role || 'user', author_name: authorName })

      // Buscar likes do post
      const { data: postLikes } = await supabase
        .from('forum_post_likes')
        .select('*')
        .eq('post_id', postId)

      setLikeCount(postLikes?.length || 0)
      setLiked(postLikes?.some(l => l.user_id === user.id) || false)

      // Buscar respostas
      const { data: repliesData } = await supabase
        .from('forum_replies')
        .select('*')
        .eq('post_id', postId)
        .order('is_solution', { ascending: false })
        .order('created_at', { ascending: true })

      if (repliesData && repliesData.length > 0) {
        const replyIds = repliesData.map(r => r.id)
        const replyUserIds = [...new Set(repliesData.map(r => r.user_id))]

        // Roles dos autores das respostas
        const { data: replyRoles } = await supabase
          .from('user_roles')
          .select('user_id, role')
          .in('user_id', replyUserIds)

        const rolesMap = {}
        replyRoles?.forEach(r => { rolesMap[r.user_id] = r.role })

        // Buscar nomes dos autores das respostas
        const { data: replyUserNames } = await supabase.rpc('get_user_names', {
          p_user_ids: replyUserIds
        })
        const namesMap = {}
        replyUserNames?.forEach(u => { namesMap[u.user_id] = u.full_name })

        // Likes das respostas
        const { data: allReplyLikes } = await supabase
          .from('forum_reply_likes')
          .select('*')
          .in('reply_id', replyIds)

        const likesMap = {}
        replyIds.forEach(rid => {
          const rl = allReplyLikes?.filter(l => l.reply_id === rid) || []
          likesMap[rid] = {
            count: rl.length,
            liked: rl.some(l => l.user_id === user.id),
          }
        })
        setReplyLikes(likesMap)

        const enriched = repliesData.map(r => ({
          ...r,
          author_name: namesMap[r.user_id] || 'Usuário',
          author_role: rolesMap[r.user_id] || 'user',
        }))
        setReplies(enriched)
      } else {
        setReplies([])
      }
    } catch (err) {
      console.error('Erro ao buscar post:', err)
    } finally {
      setLoading(false)
    }
  }

  const handleToggleLike = async () => {
    try {
      if (liked) {
        await supabase
          .from('forum_post_likes')
          .delete()
          .eq('post_id', postId)
          .eq('user_id', user.id)
        setLiked(false)
        setLikeCount(prev => prev - 1)
      } else {
        await supabase
          .from('forum_post_likes')
          .insert({ post_id: postId, user_id: user.id })
        setLiked(true)
        setLikeCount(prev => prev + 1)
      }
    } catch (err) {
      console.error('Erro ao curtir:', err)
    }
  }

  const handleToggleReplyLike = async (replyId) => {
    const current = replyLikes[replyId] || { liked: false, count: 0 }
    try {
      if (current.liked) {
        await supabase
          .from('forum_reply_likes')
          .delete()
          .eq('reply_id', replyId)
          .eq('user_id', user.id)
        setReplyLikes(prev => ({
          ...prev,
          [replyId]: { liked: false, count: current.count - 1 }
        }))
      } else {
        await supabase
          .from('forum_reply_likes')
          .insert({ reply_id: replyId, user_id: user.id })
        setReplyLikes(prev => ({
          ...prev,
          [replyId]: { liked: true, count: current.count + 1 }
        }))
      }
    } catch (err) {
      console.error('Erro ao curtir resposta:', err)
    }
  }

  const handleSubmitReply = async (e) => {
    e.preventDefault()
    if (!replyContent.trim()) return
    setSubmitting(true)

    try {
      const { error } = await supabase.from('forum_replies').insert({
        post_id: postId,
        user_id: user.id,
        content: replyContent.trim(),
      })
      if (error) throw error

      setReplyContent('')
      fetchPost()
    } catch (err) {
      console.error('Erro ao responder:', err)
      alert('Erro ao enviar resposta. Tente novamente.')
    } finally {
      setSubmitting(false)
    }
  }

  const handleDeletePost = async () => {
    if (!confirm('Tem certeza que deseja excluir este post?')) return
    try {
      await supabase.from('forum_posts').delete().eq('id', postId)
      navigate('/forum')
    } catch (err) {
      console.error('Erro ao excluir post:', err)
    }
  }

  const handleDeleteReply = async (replyId) => {
    if (!confirm('Excluir esta resposta?')) return
    try {
      await supabase.from('forum_replies').delete().eq('id', replyId)
      fetchPost()
    } catch (err) {
      console.error('Erro ao excluir resposta:', err)
    }
  }

  const handleMarkSolution = async (replyId) => {
    try {
      // Desmarcar todas as soluções do post
      await supabase
        .from('forum_replies')
        .update({ is_solution: false })
        .eq('post_id', postId)

      // Marcar essa como solução
      await supabase
        .from('forum_replies')
        .update({ is_solution: true })
        .eq('id', replyId)

      fetchPost()
    } catch (err) {
      console.error('Erro ao marcar solução:', err)
    }
  }

  const formatDate = (dateStr) => {
    const date = new Date(dateStr)
    return date.toLocaleDateString('pt-BR', {
      day: '2-digit',
      month: 'short',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
    })
  }

  const getInitials = (name) => {
    if (!name) return '??'
    if (name.includes(' ')) {
      const parts = name.split(' ')
      return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase()
    }
    return name.substring(0, 2).toUpperCase()
  }

  const getCategoryLabel = (cat) => {
    const map = { pergunta: '❓ Pergunta', discussao: '💬 Discussão', insight: '💡 Insight' }
    return map[cat] || cat
  }

  if (loading) {
    return <div className="forum-post-page"><div className="forum-post-loading">Carregando...</div></div>
  }

  if (!post) {
    return <div className="forum-post-page"><div className="forum-post-loading">Post não encontrado.</div></div>
  }

  const isAuthor = post.user_id === user.id
  const canDelete = isAuthor || isAdmin

  return (
    <div className="forum-post-page">
      <Link to="/forum" className="back-link">
        <FiArrowLeft /> Voltar ao fórum
      </Link>

      {/* Post */}
      <div className="forum-post-main">
        <div className="post-top-bar">
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

        <h1 className="post-title">{post.title}</h1>

        <div className="post-meta">
          <div className="author-info">
            <span className={`post-author-avatar ${post.author_role === 'monitor' ? 'monitor' : ''}`}>
              {getInitials(post.author_name)}
            </span>
            <span className="post-author-name">{post.author_name || 'Usuário'}</span>
            {post.author_role === 'monitor' && (
              <span className="post-author-role monitor">Monitor</span>
            )}
            <span>• {formatDate(post.created_at)}</span>
          </div>
        </div>

        <div className="post-content">{post.content}</div>

        <div className="post-actions-bar">
          <button className={`btn-like ${liked ? 'liked' : ''}`} onClick={handleToggleLike}>
            <FiThumbsUp /> {likeCount}
          </button>
          <span style={{ color: '#999', fontSize: '0.82rem', display: 'flex', alignItems: 'center', gap: '0.25rem' }}>
            <FiMessageSquare /> {replies.length} resposta{replies.length !== 1 ? 's' : ''}
          </span>
          {canDelete && (
            <button className="btn-delete-post" onClick={handleDeletePost}>
              <FiTrash2 /> Excluir
            </button>
          )}
        </div>
      </div>

      {/* Reply Form */}
      <div className="forum-replies-section">
        <h3><FiMessageSquare /> Respostas</h3>

        <div className="reply-form-card">
          <form onSubmit={handleSubmitReply}>
            <textarea
              placeholder="Escreva sua resposta..."
              value={replyContent}
              onChange={e => setReplyContent(e.target.value)}
              rows={3}
            />
            <div className="reply-form-actions">
              <button type="submit" className="btn-submit-reply" disabled={submitting || !replyContent.trim()}>
                {submitting ? 'Enviando...' : 'Responder'}
              </button>
            </div>
          </form>
        </div>

        {/* Replies List */}
        {replies.length === 0 ? (
          <div className="no-replies">Nenhuma resposta ainda. Seja o primeiro a responder!</div>
        ) : (
          replies.map(reply => {
            const rl = replyLikes[reply.id] || { liked: false, count: 0 }
            const isReplyAuthor = reply.user_id === user.id
            const canDeleteReply = isReplyAuthor || isAdmin
            const canMarkSolution = isAuthor && post.category === 'pergunta'

            return (
              <div key={reply.id} className={`reply-card ${reply.is_solution ? 'solution' : ''}`}>
                <div className="reply-header">
                  <div className="reply-author">
                    <span className={`post-author-avatar ${reply.author_role === 'monitor' ? 'monitor' : ''}`}>
                      {getInitials(reply.author_name)}
                    </span>
                    <span className="post-author-name">{reply.author_name || 'Usuário'}</span>
                    {reply.author_role === 'monitor' && (
                      <span className="post-author-role monitor">Monitor</span>
                    )}
                    <span>{formatDate(reply.created_at)}</span>
                  </div>
                  {reply.is_solution && (
                    <span className="reply-solution-badge"><FiCheckCircle /> Solução</span>
                  )}
                </div>

                <div className="reply-content">{reply.content}</div>

                <div className="reply-actions">
                  <button
                    className={`btn-reply-like ${rl.liked ? 'liked' : ''}`}
                    onClick={() => handleToggleReplyLike(reply.id)}
                  >
                    <FiThumbsUp /> {rl.count}
                  </button>

                  {canMarkSolution && !reply.is_solution && (
                    <button className="btn-mark-solution" onClick={() => handleMarkSolution(reply.id)}>
                      <FiCheckCircle /> Marcar como solução
                    </button>
                  )}

                  {canDeleteReply && (
                    <button className="btn-delete-reply" onClick={() => handleDeleteReply(reply.id)}>
                      <FiTrash2 /> Excluir
                    </button>
                  )}
                </div>
              </div>
            )
          })
        )}
      </div>
    </div>
  )
}
