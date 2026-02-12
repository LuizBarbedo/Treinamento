import { useState } from 'react'
import { useAuth } from '../contexts/AuthContext'
import { useNavigate, Link } from 'react-router-dom'
import { FiShield } from 'react-icons/fi'
import './Login.css'

export default function Login() {
  const [isSignUp, setIsSignUp] = useState(false)
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [fullName, setFullName] = useState('')
  const [isMonitorSignUp, setIsMonitorSignUp] = useState(false)
  const [monitorCode, setMonitorCode] = useState('')
  const [error, setError] = useState('')
  const [message, setMessage] = useState('')
  const [loading, setLoading] = useState(false)
  const { signIn, signUp } = useAuth()
  const navigate = useNavigate()

  const handleSubmit = async (e) => {
    e.preventDefault()
    setError('')
    setMessage('')
    setLoading(true)

    if (isSignUp) {
      if (isMonitorSignUp && !monitorCode.trim()) {
        setError('Informe o código de acesso do monitor.')
        setLoading(false)
        return
      }

      const { error, monitorError } = await signUp(
        email,
        password,
        fullName,
        isMonitorSignUp ? monitorCode.trim() : null
      )
      if (error) {
        setError(error.message)
      } else if (monitorError) {
        setError(monitorError)
      } else {
        setMessage(
          isMonitorSignUp
            ? 'Conta de monitor criada! Verifique seu e-mail para confirmar o cadastro.'
            : 'Conta criada! Verifique seu e-mail para confirmar o cadastro.'
        )
      }
    } else {
      const { error } = await signIn(email, password)
      if (error) {
        console.error('Login error:', error)
        setError(error.message || 'E-mail ou senha incorretos.')
      } else {
        navigate('/')
      }
    }
    setLoading(false)
  }

  return (
    <div className="login-container">
      <div className="login-card">
        <div className="login-header">
          <h1>🎓 Treinamento</h1>
          <p>Plataforma de Ensino Corporativo</p>
        </div>

        <form onSubmit={handleSubmit} className="login-form">
          <h2>{isSignUp ? 'Criar Conta' : 'Entrar'}</h2>

          {isSignUp && (
            <div className="form-group">
              <label>Nome Completo</label>
              <input
                type="text"
                value={fullName}
                onChange={(e) => setFullName(e.target.value)}
                placeholder="Seu nome completo"
                required
              />
            </div>
          )}

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
              minLength={6}
            />
          </div>

          {error && <div className="form-error">{error}</div>}
          {message && <div className="form-success">{message}</div>}

          <button type="submit" className="btn-primary" disabled={loading}>
            {loading ? 'Aguarde...' : isSignUp ? (isMonitorSignUp ? 'Criar Conta de Monitor' : 'Criar Conta') : 'Entrar'}
          </button>

          {isSignUp && (
            <div className={`monitor-signup-toggle ${isMonitorSignUp ? 'active' : ''}`}>
              <button
                type="button"
                className="btn-monitor-toggle"
                onClick={() => {
                  setIsMonitorSignUp(!isMonitorSignUp)
                  setMonitorCode('')
                  setError('')
                }}
              >
                <FiShield /> {isMonitorSignUp ? 'Cancelar cadastro como monitor' : 'Sou Monitor'}
              </button>

              {isMonitorSignUp && (
                <div className="monitor-code-section">
                  <p className="monitor-code-hint">Insira o código de acesso fornecido pelo administrador</p>
                  <div className="form-group">
                    <label>Código de Acesso</label>
                    <input
                      type="text"
                      value={monitorCode}
                      onChange={(e) => setMonitorCode(e.target.value.toUpperCase())}
                      placeholder="Ex: MONITOR2026"
                      required
                      className="monitor-code-input"
                    />
                  </div>
                </div>
              )}
            </div>
          )}

          {!isSignUp && (
            <p className="forgot-password">
              <Link to="/esqueci-senha" className="btn-link">Esqueci minha senha</Link>
            </p>
          )}

          <p className="toggle-auth">
            {isSignUp ? 'Já tem uma conta?' : 'Não tem uma conta?'}{' '}
            <button
              type="button"
              className="btn-link"
              onClick={() => {
                setIsSignUp(!isSignUp)
                setError('')
                setMessage('')
                setIsMonitorSignUp(false)
                setMonitorCode('')
              }}
            >
              {isSignUp ? 'Fazer login' : 'Criar conta'}
            </button>
          </p>
        </form>
      </div>
    </div>
  )
}
