import { useEffect, useState } from 'react'
import { useParams, Link, useNavigate } from 'react-router-dom'
import { supabase } from '../../lib/supabase'
import { useAuth } from '../../contexts/AuthContext'
import { FiArrowLeft, FiSend, FiCheckCircle } from 'react-icons/fi'
import './MonitorDoubtDetail.css'

export default function MonitorDoubtDetail() {
  const { doubtId } = useParams()
  const { user, isMonitor } = useAuth()
  const navigate = useNavigate()
  const [loading, setLoading] = useState(true)
  const [doubt, setDoubt] = useState(null)
  const [replies, setReplies] = useState([])
  const [newReply, setNewReply] = useState('')
  const [sending, setSending] = useState(false)
  const [studentName, setStudentName] = useState('')

  useEffect(() => {
    if (user && doubtId) fetchData()
  }, [user, doubtId])

  const fetchData = async () => {
    try {
      // Buscar a dúvida
      const { data: doubtData } = await supabase
        .from('doubts')
        .select('*, disciplines(name), lessons(title)')
        .eq('id', doubtId)
        .single()

      if (!doubtData) {
        setLoading(false)
        return
      }
      setDoubt(doubtData)

      // Buscar respostas
      const { data: repliesData } = await supabase
        .from('doubt_replies')
        .select('*')
        .eq('doubt_id', doubtId)
        .order('created_at')

      setReplies(repliesData || [])

      // Se é monitor, buscar nome do aluno
      if (isMonitor && doubtData.user_id !== user.id) {
        const { data: students } = await supabase.rpc('get_monitor_students', {
          p_monitor_id: user.id
        })
        const student = (students || []).find(s => s.id === doubtData.user_id)
        setStudentName(student?.full_name || student?.email || 'Aluno')
      }
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

      // Se é monitor respondendo, mudar status para 'answered'
      if (isMonitor && doubt.status === 'open') {
        await supabase
          .from('doubts')
          .update({ status: 'answered' })
          .eq('id', doubtId)
        setDoubt(prev => ({ ...prev, status: 'answered' }))
      }

      setNewReply('')
      fetchData() // Recarregar respostas
    } catch (err) {
      console.error('Erro ao enviar resposta:', err)
      alert('Erro ao enviar resposta. Tente novamente.')
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

  const isOwnMessage = (replyUserId) => replyUserId === user.id

  const getStatusLabel = (status) => {
    switch (status) {
      case 'open': return 'Aberta'
      case 'answered': return 'Respondida'
      case 'resolved': return 'Resolvida'
      default: return status
    }
  }

  const backUrl = isMonitor ? '/monitor/duvidas' : '/minhas-duvidas'

  if (loading) {
    return (
      <div className="doubt-detail-page">
        <div className="loading-screen">
          <div className="spinner"></div>
          <p>Carregando dúvida...</p>
        </div>
      </div>
    )
  }

  if (!doubt) {
    return (
      <div className="doubt-detail-page">
        <div className="empty-state">
          <p>Dúvida não encontrada.</p>
          <Link to={backUrl} className="btn-back">← Voltar</Link>
        </div>
      </div>
    )
  }

  return (
    <div className="doubt-detail-page">
      <Link to={backUrl} className="btn-back"><FiArrowLeft /> Voltar</Link>

      {/* Dúvida principal */}
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
          {doubt.status !== 'resolved' && (
            <button className="btn-resolve" onClick={handleResolve}>
              <FiCheckCircle /> Marcar como resolvida
            </button>
          )}
        </div>

        <h1 className="doubt-main-title">{doubt.title}</h1>

        <div className="doubt-tags">
          {isMonitor && studentName && (
            <span className="tag tag-student">👤 {studentName}</span>
          )}
          <span className="tag tag-disc">📚 {doubt.disciplines?.name}</span>
          {doubt.lessons?.title && (
            <span className="tag tag-lesson">📖 {doubt.lessons.title}</span>
          )}
        </div>

        <div className="doubt-main-body">
          {doubt.description}
        </div>
      </div>

      {/* Respostas */}
      <div className="replies-section">
        <h3>Respostas ({replies.length})</h3>

        {replies.length === 0 && doubt.status === 'open' && (
          <div className="no-replies">
            <p>Nenhuma resposta ainda. {isMonitor ? 'Responda a dúvida do aluno.' : 'Aguarde a resposta do monitor.'}</p>
          </div>
        )}

        <div className="replies-list">
          {replies.map(reply => (
            <div
              key={reply.id}
              className={`reply-bubble ${isOwnMessage(reply.user_id) ? 'own' : 'other'}`}
            >
              <div className="reply-header">
                <span className="reply-author">
                  {isOwnMessage(reply.user_id) ? 'Você' : (isMonitor ? 'Aluno' : '🎓 Monitor')}
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

        {/* Form de resposta */}
        {doubt.status !== 'resolved' && (
          <form className="reply-form" onSubmit={handleSendReply}>
            <textarea
              placeholder={isMonitor ? 'Escreva sua resposta para o aluno...' : 'Escreva uma mensagem...'}
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
