import { NavLink, Outlet, useNavigate } from 'react-router-dom'
import { useAuth } from '../contexts/AuthContext'
import { FiHome, FiBook, FiLogOut, FiUser, FiSettings } from 'react-icons/fi'
import './Layout.css'

export default function Layout() {
  const { user, signOut, isAdmin } = useAuth()
  const navigate = useNavigate()

  const handleSignOut = async () => {
    await signOut()
    navigate('/login')
  }

  const displayName = user?.user_metadata?.full_name || user?.email?.split('@')[0] || 'Usuário'

  return (
    <div className="layout">
      <aside className="sidebar">
        <div className="sidebar-header">
          <h2>🎓 Treinamento</h2>
        </div>

        <nav className="sidebar-nav">
          <NavLink to="/" end className={({ isActive }) => isActive ? 'nav-item active' : 'nav-item'}>
            <FiHome /> <span>Início</span>
          </NavLink>
          <NavLink to="/disciplinas" className={({ isActive }) => isActive ? 'nav-item active' : 'nav-item'}>
            <FiBook /> <span>Disciplinas</span>
          </NavLink>

          {isAdmin && (
            <>
              <div className="nav-divider" />
              <span className="nav-section-label">Admin</span>
              <NavLink to="/admin/disciplinas" className={({ isActive }) => isActive ? 'nav-item active' : 'nav-item'}>
                <FiSettings /> <span>Gerenciar</span>
              </NavLink>
            </>
          )}
        </nav>

        <div className="sidebar-footer">
          <div className="user-info">
            <FiUser />
            <span className="user-name">{displayName}</span>
          </div>
          <button className="btn-logout" onClick={handleSignOut}>
            <FiLogOut /> Sair
          </button>
        </div>
      </aside>

      <main className="main-content">
        <Outlet />
      </main>
    </div>
  )
}
