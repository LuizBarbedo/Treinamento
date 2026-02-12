import { useEffect, useState } from 'react'
import { useParams, Link } from 'react-router-dom'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'
import { FiArrowLeft, FiSend, FiCheckCircle } from 'react-icons/fi'
import '../pages/monitor/MonitorDoubtDetail.css'

export default function StudentDoubtDetail() {
  const { doubtId } = useParams()
  const { user } = useAuth()
  const [loading, setLoading] = useState(true)
  const [doubt, setDoubt] = useState(null)
  const [replies, setReplies] = useState([])
  const [newReply, setNewReply] = useState('')
  const [sending, setSending] = useState(false)

  useEffect(() => {
    if (user && doubtId) fetchData()
  }, [user, doubtId])

  const fetchData = async () => {
    try {
      const [doubtRes, repliesRes] = await Promise.all([
        supabase
          .from('doubts')
          .select('*, disciplines(name), lessons(title)')
          .eq('id', doubtId)
          .eq('user_id', user.id)
          .single(),
        supabase
          .from('doubt_replies')
          .select('*')
          .eq('doubt_id', doubtId)
          .order('created_at'),
      ])

      setDoubt(doubtRes.data)
      setReplies(repliesRes.data || [])
    } catch (err) {
      console.error('Erro ao buscar dúvida:', err)
    } finally {
      setLoading(false)
    }
  }

  const handleSendReply = async (e) => {
    e.preventDefault()
    if (!newReply.trim() || sending) return

    setSending(true)
    try {
      const { error } = await supabase.from('doubt_replies').insert({
        doubt_id: doubtId,
        user_id: user.id,
        message: newReply.trim(),
      })

      if (error) throw error
      setNewReply('')
      fetchData()
    } catch (err) {
      console.error('Erro ao enviar resposta:', err)
      alert('Erro ao enviar mensagem.')
    } finally {
      setSending(false)
    }
  }

  const handleResolve = async () => {
    try {
      await supabase
        .from('doubts')
        .update({ status: 'resolved' })
        .eq('id', doubtId)
      setDoubt(prev => ({ ...prev, status: 'resolved' }))
    } catch (err) {
      console.error('Erro ao resolver dúvida:', err)
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

  if (loading) {
    return (
      <div className="doubt-detail-page">
        <div className="loading-screen">
          <div className="spinner"></div>
          <p>Carregando...</p>
        </div>
      </div>
    )
  }

  if (!doubt) {
    return (
      <div className="doubt-detail-page">
        <div className="empty-state">
          <p>Dúvida não encontrada.</p>
          <Link to="/minhas-duvidas" className="btn-back">← Voltar</Link>
        </div>
      </div>
    )
  }

  return (
    <div className="doubt-detail-page">
      <Link to="/minhas-duvidas" className="btn-back"><FiArrowLeft /> Voltar</Link>

      <div className="doubt-main">
        <div className="doubt-main-header">
          <div>
            <span className={`doubt-status status-${doubt.status}`}>
              {getStatusLabel(doubt.status)}
            </span>
            <span className="doubt-date-full">
              {new Date(doubt.created_at).toLocaleDateString('pt-BR', {
                day: '2-digit', month: 'long', year: 'numeric',
                hour: '2-digit', minute: '2-digit'
              })}
            </span>
          </div>
          {doubt.status === 'answered' && (
            <button className="btn-resolve" onClick={handleResolve}>
              <FiCheckCircle /> Marcar como resolvida
            </button>
          )}
        </div>

        <h1 className="doubt-main-title">{doubt.title}</h1>

        <div className="doubt-tags">
          <span className="tag tag-disc">📚 {doubt.disciplines?.name}</span>
          {doubt.lessons?.title && (
            <span className="tag tag-lesson">📖 {doubt.lessons.title}</span>
          )}
        </div>

        <div className="doubt-main-body">{doubt.description}</div>
      </div>

      <div className="replies-section">
        <h3>Respostas ({replies.length})</h3>

        {replies.length === 0 && doubt.status === 'open' && (
          <div className="no-replies">
            <p>Aguardando resposta do monitor...</p>
          </div>
        )}

        <div className="replies-list">
          {replies.map(reply => (
            <div
              key={reply.id}
              className={`reply-bubble ${reply.user_id === user.id ? 'own' : 'other'}`}
            >
              <div className="reply-header">
                <span className="reply-author">
                  {reply.user_id === user.id ? 'Você' : '🎓 Monitor'}
                </span>
                <span className="reply-time">
                  {new Date(reply.created_at).toLocaleDateString('pt-BR', {
                    day: '2-digit', month: '2-digit',
                    hour: '2-digit', minute: '2-digit'
                  })}
                </span>
              </div>
              <p className="reply-message">{reply.message}</p>
            </div>
          ))}
        </div>

        {doubt.status !== 'resolved' && (
          <form className="reply-form" onSubmit={handleSendReply}>
            <textarea
              placeholder="Escreva uma mensagem..."
              value={newReply}
              onChange={e => setNewReply(e.target.value)}
              rows={3}
            />
            <button type="submit" disabled={!newReply.trim() || sending} className="btn-send">
              <FiSend /> {sending ? 'Enviando...' : 'Enviar'}
            </button>
          </form>
        )}

        {doubt.status === 'resolved' && (
          <div className="resolved-notice">
            <FiCheckCircle /> Esta dúvida foi resolvida.
          </div>
        )}
      </div>
    </div>
  )
}
