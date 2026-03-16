import { useState } from 'react'
import { useAuth } from '../contexts/AuthContext'
import { useNavigate, Link } from 'react-router-dom'
import logoImg from '../assets/logo-branco-aprendiz-longa.png'
import './Login.css'

export default function Login() {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)
  const { signIn } = useAuth()
  const navigate = useNavigate()

  const handleSubmit = async (e) => {
    e.preventDefault()
    setError('')
    setLoading(true)

    const { error, mustResetPassword } = await signIn(email, password)
    if (error) {
      console.error('Login error:', error)
      setError(error.message || 'E-mail ou senha incorretos.')
    } else {
      navigate(mustResetPassword ? '/redefinir-senha' : '/')
    }
    setLoading(false)
  }

  return (
    <div className="login-container">
      <div className="login-card">
        <div className="login-header">
          <img src={logoImg} alt="Aprendiz" className="login-logo" />
        </div>

        <form onSubmit={handleSubmit} className="login-form">
          <h2>Entrar</h2>

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

          <div className="form-group">
            <label>Senha</label>
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="Sua senha"
              required
            />
          </div>

          {error && <div className="form-error">{error}</div>}

          <button type="submit" className="btn-primary" disabled={loading}>
            {loading ? 'Aguarde...' : 'Entrar'}
          </button>

          <p className="forgot-password">
            <Link to="/esqueci-senha" className="btn-link">Esqueci minha senha</Link>
          </p>
        </form>
      </div>
    </div>
  )
}
