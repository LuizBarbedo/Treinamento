import { useState, useRef, useEffect } from 'react'
import { FiMessageCircle, FiX, FiSend } from 'react-icons/fi'
import { sendMessage } from '../lib/gemini'
import './AIChat.css'

export default function AIChat({ discipline, lessons = [], materials = [] }) {
  const [isOpen, setIsOpen] = useState(false)
  const [messages, setMessages] = useState([
    {
      role: 'assistant',
      text: `Olá! Sou seu assistente para **${discipline?.name || 'esta disciplina'}**. Pergunte qualquer dúvida sobre o conteúdo! 😊`
    }
  ])
  const [input, setInput] = useState('')
  const [isLoading, setIsLoading] = useState(false)
  const messagesEndRef = useRef(null)
  const inputRef = useRef(null)

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' })
  }, [messages])

  useEffect(() => {
    if (isOpen) {
      inputRef.current?.focus()
    }
  }, [isOpen])

  const handleSend = async () => {
    const trimmed = input.trim()
    if (!trimmed || isLoading) return

    const userMessage = { role: 'user', text: trimmed }
    setMessages(prev => [...prev, userMessage])
    setInput('')
    setIsLoading(true)

    // Passar o histórico sem a mensagem de boas-vindas
    const chatHistory = messages.slice(1).map(m => ({
      role: m.role === 'assistant' ? 'model' : 'user',
      text: m.text
    }))

    const response = await sendMessage(trimmed, discipline, lessons, materials, chatHistory)

    setMessages(prev => [...prev, { role: 'assistant', text: response }])
    setIsLoading(false)
  }

  const handleKeyDown = (e) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault()
      handleSend()
    }
  }

  // Renderizar texto com formatação básica (negrito)
  const renderText = (text) => {
    const parts = text.split(/(\*\*.*?\*\*)/g)
    return parts.map((part, i) => {
      if (part.startsWith('**') && part.endsWith('**')) {
        return <strong key={i}>{part.slice(2, -2)}</strong>
      }
      return <span key={i}>{part}</span>
    })
  }

  if (!discipline) return null

  return (
    <>
      {/* Botão flutuante */}
      <button
        className={`chat-fab ${isOpen ? 'hidden' : ''}`}
        onClick={() => setIsOpen(true)}
        title="Tirar dúvidas com IA"
      >
        <FiMessageCircle />
        <span className="fab-label">Dúvidas?</span>
      </button>

      {/* Painel do chat */}
      <div className={`chat-panel ${isOpen ? 'open' : ''}`}>
        <div className="chat-header">
          <div className="chat-header-info">
            <span className="chat-avatar">🤖</span>
            <div>
              <h3>Assistente IA</h3>
              <span className="chat-discipline">{discipline.name}</span>
            </div>
          </div>
          <button className="chat-close" onClick={() => setIsOpen(false)}>
            <FiX />
          </button>
        </div>

        <div className="chat-messages">
          {messages.map((msg, i) => (
            <div key={i} className={`chat-msg ${msg.role}`}>
              {msg.role === 'assistant' && <span className="msg-avatar">🤖</span>}
              <div className="msg-bubble">
                {renderText(msg.text)}
              </div>
            </div>
          ))}

          {isLoading && (
            <div className="chat-msg assistant">
              <span className="msg-avatar">🤖</span>
              <div className="msg-bubble typing">
                <span className="dot"></span>
                <span className="dot"></span>
                <span className="dot"></span>
              </div>
            </div>
          )}

          <div ref={messagesEndRef} />
        </div>

        <div className="chat-input-area">
          <textarea
            ref={inputRef}
            value={input}
            onChange={(e) => setInput(e.target.value)}
            onKeyDown={handleKeyDown}
            placeholder="Digite sua dúvida..."
            rows={1}
            disabled={isLoading}
          />
          <button
            className="chat-send"
            onClick={handleSend}
            disabled={!input.trim() || isLoading}
          >
            <FiSend />
          </button>
        </div>
      </div>
    </>
  )
}
