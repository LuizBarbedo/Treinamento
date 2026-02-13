import { useState, useEffect, useCallback } from 'react'
import { NavLink, Outlet, useNavigate } from 'react-router-dom'
import { useAuth } from '../contexts/AuthContext'
import { supabase } from '../lib/supabase'
import { FiHome, FiBook, FiLogOut, FiUser, FiSettings, FiBarChart2, FiAward, FiMessageCircle, FiUsers, FiClipboard, FiMessageSquare, FiMenu, FiX } from 'react-icons/fi'
import './Layout.css'

export default function Layout() {
  const { user, signOut, isAdmin, isMonitor } = useAuth()
  const navigate = useNavigate()
  const [collapsed, setCollapsed] = useState(true)
  const [hovering, setHovering] = useState(false)
  const [doubtsBadge, setDoubtsBadge] = useState(0)

  const fetchDoubtsBadge = useCallback(async () => {
    if (!user) return

    try {
      if (isMonitor) {
        // Monitor: contar dúvidas abertas dos alunos vinculados
        const { data: students } = await supabase
          .from('monitor_students')
          .select('student_id')
          .eq('monitor_id', user.id)

        if (students && students.length > 0) {
          const studentIds = students.map(s => s.student_id)
          const { count } = await supabase
            .from('doubts')
            .select('*', { count: 'exact', head: true })
            .in('user_id', studentIds)
            .eq('status', 'open')

          setDoubtsBadge(count || 0)
        } else {
          setDoubtsBadge(0)
        }
      } else if (!isAdmin) {
        // Aluno: contar dúvidas respondidas pelo monitor mas não visualizadas
        const { count } = await supabase
          .from('doubts')
          .select('*', { count: 'exact', head: true })
          .eq('user_id', user.id)
          .eq('status', 'answered')

        setDoubtsBadge(count || 0)
      }
    } catch (err) {
      console.error('Erro ao buscar notificações de dúvidas:', err)
    }
  }, [user, isMonitor, isAdmin])

  useEffect(() => {
    fetchDoubtsBadge()

    // Atualizar a cada 30 segundos
    const interval = setInterval(fetchDoubtsBadge, 30000)
    return () => clearInterval(interval)
  }, [fetchDoubtsBadge])

  const expanded = !collapsed || hovering

  const handleSignOut = async () => {
    await signOut()
    navigate('/login')
  }

  const displayName = user?.user_metadata?.full_name || user?.email?.split('@')[0] || 'Usuário'

  return (
    <div className={`layout ${expanded ? 'sidebar-expanded' : 'sidebar-collapsed'}`}>
      <aside
        className={`sidebar ${expanded ? 'expanded' : 'collapsed'}`}
        onMouseEnter={() => setHovering(true)}
        onMouseLeave={() => setHovering(false)}
      >
        <div className="sidebar-header">
          <span className="sidebar-logo">🎓</span>
          <h2 className="sidebar-title">Treinamento</h2>
          <button
            className="sidebar-toggle"
            onClick={() => setCollapsed(prev => !prev)}
            title={collapsed ? 'Fixar menu' : 'Recolher menu'}
          >
            {collapsed ? <FiMenu /> : <FiX />}
          </button>
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
          <NavLink to="/forum" className={({ isActive }) => isActive ? 'nav-item active' : 'nav-item'}>
            <FiMessageSquare /> <span>Fórum</span>
          </NavLink>

          {/* Dúvidas - visível para alunos (não monitor, não admin) */}
          {!isAdmin && !isMonitor && (
            <NavLink to="/minhas-duvidas" className={({ isActive }) => isActive ? 'nav-item active' : 'nav-item'}>
              <span className="nav-icon-wrapper">
                <FiMessageCircle />
                {doubtsBadge > 0 && <span className="nav-badge">{doubtsBadge}</span>}
              </span>
              <span>Dúvidas</span>
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
                <FiUsers /> <span>Meus Alunos</span>
              </NavLink>
              <NavLink to="/monitor/duvidas" className={({ isActive }) => isActive ? 'nav-item active' : 'nav-item'}>
                <span className="nav-icon-wrapper">
                  <FiMessageCircle />
                  {doubtsBadge > 0 && <span className="nav-badge">{doubtsBadge}</span>}
                </span>
                <span>Dúvidas/Monitor</span>
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
              <NavLink to="/admin/relatorio-monitores" className={({ isActive }) => isActive ? 'nav-item active' : 'nav-item'}>
                <FiClipboard /> <span>Rel. Monitores</span>
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
