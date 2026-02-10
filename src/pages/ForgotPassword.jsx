import { useState } from 'react'
import { useAuth } from '../contexts/AuthContext'
import { Link } from 'react-router-dom'
import './ForgotPassword.css'

export default function ForgotPassword() {
  const [email, setEmail] = useState('')
  const [error, setError] = useState('')
  const [message, setMessage] = useState('')
  const [loading, setLoading] = useState(false)
  const { resetPassword } = useAuth()

  const handleSubmit = async (e) => {
    e.preventDefault()
    setError('')
    setMessage('')
    setLoading(true)

    const { error } = await resetPassword(email)
    if (error) {
      setError(error.message)
    } else {
      setMessage('E-mail de recuperação enviado! Verifique sua caixa de entrada (e spam).')
    }
    setLoading(false)
  }

  return (
    <div className="login-container">
      <div className="login-card">
        <div className="login-header">
          <h1>🎓 Treinamento</h1>
          <p>Recuperação de Senha</p>
        </div>

        <form onSubmit={handleSubmit} className="login-form">
          <h2>Esqueci minha senha</h2>
          <p className="forgot-description">
            Informe seu e-mail cadastrado e enviaremos um link para redefinir sua senha.
          </p>

          <div className="form-group">
            <label>E-mail</label>
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="seu@email.com"
              required
            />
          </div>

          {error && <div className="form-error">{error}</div>}
          {message && <div className="form-success">{message}</div>}

          <button type="submit" className="btn-primary" disabled={loading}>
            {loading ? 'Enviando...' : 'Enviar link de recuperação'}
          </button>

          <p className="toggle-auth">
            <Link to="/login" className="btn-link">← Voltar para o login</Link>
          </p>
        </form>
      </div>
    </div>
  )
}
