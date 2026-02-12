import { NavLink, Outlet, useNavigate } from 'react-router-dom'
import { useAuth } from '../contexts/AuthContext'
import { FiHome, FiBook, FiLogOut, FiUser, FiSettings, FiBarChart2, FiAward, FiMessageCircle, FiUsers, FiClipboard } from 'react-icons/fi'
import './Layout.css'

export default function Layout() {
  const { user, signOut, isAdmin, isMonitor } = useAuth()
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
          <NavLink to="/conquistas" className={({ isActive }) => isActive ? 'nav-item active' : 'nav-item'}>
            <FiAward /> <span>Conquistas</span>
          </NavLink>

          {/* Dúvidas - visível para alunos (não monitor, não admin) */}
          {!isAdmin && !isMonitor && (
            <NavLink to="/minhas-duvidas" className={({ isActive }) => isActive ? 'nav-item active' : 'nav-item'}>
              <FiMessageCircle /> <span>Dúvidas</span>
            </NavLink>
          )}

          {/* Monitor Routes */}
          {isMonitor && (
            <>
              <div className="nav-divider" />
              <span className="nav-section-label">Monitor</span>
              <NavLink to="/monitor" end className={({ isActive }) => isActive ? 'nav-item active' : 'nav-item'}>
                <FiClipboard /> <span>Painel</span>
              </NavLink>
              <NavLink to="/monitor/alunos" className={({ isActive }) => isActive ? 'nav-item active' : 'nav-item'}>
                <FiUsers /> <span>Alunos</span>
              </NavLink>
              <NavLink to="/monitor/duvidas" className={({ isActive }) => isActive ? 'nav-item active' : 'nav-item'}>
                <FiMessageCircle /> <span>Dúvidas</span>
              </NavLink>
            </>
          )}

          {isAdmin && (
            <>
              <div className="nav-divider" />
              <span className="nav-section-label">Admin</span>
              <NavLink to="/admin/disciplinas" className={({ isActive }) => isActive ? 'nav-item active' : 'nav-item'}>
                <FiSettings /> <span>Gerenciar</span>
              </NavLink>
              <NavLink to="/admin/relatorios" className={({ isActive }) => isActive ? 'nav-item active' : 'nav-item'}>
                <FiBarChart2 /> <span>Relatórios</span>
              </NavLink>
              <NavLink to="/admin/monitores" className={({ isActive }) => isActive ? 'nav-item active' : 'nav-item'}>
                <FiUsers /> <span>Monitores</span>
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
