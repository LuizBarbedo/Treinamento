import { useState, useEffect } from 'react'
import { supabase } from '../../lib/supabase'
import { FiUserPlus, FiUsers, FiRefreshCw } from 'react-icons/fi'
import './AdminUsers.css'

const ROLES = [
  { value: 'user', label: 'Aluno' },
  { value: 'monitor', label: 'Monitor' },
  { value: 'admin', label: 'Admin' },
]

const ACCESS_LEVELS = [
  { value: 'basico', label: 'Básico' },
  { value: 'intermediario', label: 'Intermediário' },
  { value: 'avancado', label: 'Avançado' },
]

export default function AdminUsers() {
  const [fullName, setFullName] = useState('')
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [role, setRole] = useState('user')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const [success, setSuccess] = useState('')

  const [users, setUsers] = useState([])
  const [usersLoading, setUsersLoading] = useState(true)

  useEffect(() => {
    fetchUsers()
  }, [])

  const fetchUsers = async () => {
    setUsersLoading(true)
    try {
      const { data } = await supabase.rpc('get_platform_users')
      setUsers(data || [])
    } catch (err) {
      console.error('Erro ao buscar usuários:', err)
    } finally {
      setUsersLoading(false)
    }
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    setError('')
    setSuccess('')
    setLoading(true)

    try {
      // Criar usuário via Supabase Auth
      const { data, error: signUpError } = await supabase.auth.signUp({
        email: email.trim(),
        password,
        options: {
          data: {
            full_name: fullName.trim(),
            must_reset_password: true,
          },
        },
      })

      if (signUpError) {
        setError(signUpError.message)
        setLoading(false)
        return
      }

      const newUserId = data?.user?.id

      // Se não for aluno comum, atribuir role
      if (newUserId && role !== 'user') {
        const { error: roleError } = await supabase
          .from('user_roles')
          .upsert({ user_id: newUserId, role }, { onConflict: 'user_id' })

        if (roleError) {
          setError('Usuário criado, mas não foi possível atribuir o papel: ' + roleError.message)
          setLoading(false)
          return
        }
      }

      setSuccess(
        `Conta criada com sucesso! O usuário receberá um e-mail para confirmar o cadastro e deverá redefinir a senha no primeiro acesso.`
      )
      setFullName('')
      setEmail('')
      setPassword('')
      setRole('user')
      fetchUsers()
    } catch (err) {
      setError('Ocorreu um erro inesperado. Tente novamente.')
      console.error(err)
    } finally {
      setLoading(false)
    }
  }

  const handleAccessLevelChange = async (userId, newLevel) => {
    const previous = users
    setUsers((prev) =>
      prev.map((u) => (u.id === userId ? { ...u, access_level: newLevel } : u))
    )
    const { error: rpcError } = await supabase.rpc('set_user_access_level', {
      p_user_id: userId,
      p_access_level: newLevel,
    })
    if (rpcError) {
      setUsers(previous)
      setError('Não foi possível atualizar o nível de acesso: ' + rpcError.message)
    }
  }

  const getRoleLabel = (userId, email) => {
    // Verificar na lista de usuários se tem role
    const user = users.find(u => u.id === userId || u.email === email)
    if (!user) return 'Aluno'
    if (user.role === 'admin') return 'Admin'
    if (user.role === 'monitor') return 'Monitor'
    return 'Aluno'
  }

  return (
    <div className="admin-users-page">
      <div className="page-header">
        <div>
          <h1><FiUserPlus /> Cadastrar Usuários</h1>
          <p>Crie novas contas de acesso à plataforma</p>
        </div>
      </div>

      {/* Formulário de cadastro */}
      <div className="admin-users-card">
        <h2>Nova Conta</h2>
        <form onSubmit={handleSubmit} className="admin-users-form">
          <div className="form-row">
            <div className="form-group">
              <label>Nome Completo</label>
              <input
                type="text"
                value={fullName}
                onChange={(e) => setFullName(e.target.value)}
                placeholder="Nome completo do usuário"
                required
              />
            </div>
            <div className="form-group">
              <label>E-mail</label>
              <input
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="email@exemplo.com"
                required
              />
            </div>
          </div>

          <div className="form-row">
            <div className="form-group">
              <label>Senha Temporária</label>
              <input
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="Mínimo 6 caracteres"
                minLength={6}
                required
              />
            </div>
            <div className="form-group">
              <label>Perfil</label>
              <select value={role} onChange={(e) => setRole(e.target.value)}>
                {ROLES.map(r => (
                  <option key={r.value} value={r.value}>{r.label}</option>
                ))}
              </select>
            </div>
          </div>

          {error && <div className="form-error">{error}</div>}
          {success && <div className="form-success">{success}</div>}

          <div className="form-hint">
            O usuário receberá um e-mail de confirmação e será obrigado a redefinir a senha no primeiro acesso.
          </div>

          <button type="submit" className="btn-submit" disabled={loading}>
            <FiUserPlus />
            {loading ? 'Criando...' : 'Criar Conta'}
          </button>
        </form>
      </div>

      {/* Lista de usuários cadastrados */}
      <div className="admin-users-list-card">
        <div className="list-header">
          <h2><FiUsers /> Usuários Cadastrados</h2>
          <button className="btn-refresh" onClick={fetchUsers} disabled={usersLoading} title="Atualizar lista">
            <FiRefreshCw className={usersLoading ? 'spinning' : ''} />
          </button>
        </div>

        {usersLoading ? (
          <div className="loading-state">Carregando usuários...</div>
        ) : users.length === 0 ? (
          <div className="empty-state">Nenhum usuário encontrado.</div>
        ) : (
          <div className="users-table-wrapper">
            <table className="users-table">
              <thead>
                <tr>
                  <th>Nome</th>
                  <th>E-mail</th>
                  <th>Perfil</th>
                  <th>Nível de Acesso</th>
                </tr>
              </thead>
              <tbody>
                {users.map((u) => (
                  <tr key={u.id}>
                    <td>{u.full_name || '—'}</td>
                    <td>{u.email}</td>
                    <td>
                      <span className={`role-badge role-${u.role || 'user'}`}>
                        {ROLES.find(r => r.value === (u.role || 'user'))?.label || 'Aluno'}
                      </span>
                    </td>
                    <td>
                      <select
                        value={u.access_level || 'basico'}
                        onChange={(e) => handleAccessLevelChange(u.id, e.target.value)}
                        className="access-level-select"
                      >
                        {ACCESS_LEVELS.map((lvl) => (
                          <option key={lvl.value} value={lvl.value}>{lvl.label}</option>
                        ))}
                      </select>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  )
}
