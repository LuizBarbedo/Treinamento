import { useEffect, useState } from 'react'
import { supabase } from '../../lib/supabase'
import { FiUsers, FiPlus, FiTrash2, FiUserPlus, FiUserX, FiSearch, FiChevronDown, FiChevronUp } from 'react-icons/fi'
import './AdminMonitors.css'

export default function AdminMonitors() {
  const [loading, setLoading] = useState(true)
  const [monitors, setMonitors] = useState([])
  const [allUsers, setAllUsers] = useState([])
  const [availableStudents, setAvailableStudents] = useState([])
  const [expandedMonitor, setExpandedMonitor] = useState(null)
  const [monitorStudents, setMonitorStudents] = useState({})
  const [showAddMonitor, setShowAddMonitor] = useState(false)
  const [showAssignStudent, setShowAssignStudent] = useState(null)
  const [searchTerm, setSearchTerm] = useState('')
  const [assignSearchTerm, setAssignSearchTerm] = useState('')

  useEffect(() => {
    fetchData()
  }, [])

  const fetchData = async () => {
    try {
      const [monitorsRes, usersRes, studentsRes] = await Promise.all([
        supabase.rpc('get_monitors'),
        supabase.rpc('get_platform_users'),
        supabase.rpc('get_available_students'),
      ])

      setMonitors(monitorsRes.data || [])
      setAllUsers(usersRes.data || [])
      setAvailableStudents(studentsRes.data || [])
    } catch (err) {
      console.error('Erro ao buscar dados:', err)
    } finally {
      setLoading(false)
    }
  }

  const fetchMonitorStudents = async (monitorId) => {
    const { data } = await supabase.rpc('get_monitor_students', { p_monitor_id: monitorId })
    setMonitorStudents(prev => ({ ...prev, [monitorId]: data || [] }))
  }

  const handleExpandMonitor = async (monitorId) => {
    if (expandedMonitor === monitorId) {
      setExpandedMonitor(null)
      return
    }
    setExpandedMonitor(monitorId)
    if (!monitorStudents[monitorId]) {
      await fetchMonitorStudents(monitorId)
    }
  }

  const handlePromoteToMonitor = async (userId) => {
    try {
      // Inserir ou atualizar role para 'monitor'
      const { error } = await supabase
        .from('user_roles')
        .upsert({ user_id: userId, role: 'monitor' }, { onConflict: 'user_id' })

      if (error) throw error
      setShowAddMonitor(false)
      setSearchTerm('')
      fetchData()
    } catch (err) {
      console.error('Erro ao promover monitor:', err)
      alert('Erro ao promover usuário a monitor.')
    }
  }

  const handleRemoveMonitor = async (monitorId) => {
    if (!confirm('Tem certeza que deseja remover este monitor? Os vínculos com alunos serão removidos.')) return

    try {
      // Remover vínculos
      await supabase.from('monitor_students').delete().eq('monitor_id', monitorId)
      // Alterar role para 'user'
      await supabase.from('user_roles').update({ role: 'user' }).eq('user_id', monitorId)
      fetchData()
      setExpandedMonitor(null)
    } catch (err) {
      console.error('Erro ao remover monitor:', err)
      alert('Erro ao remover monitor.')
    }
  }

  const handleAssignStudent = async (monitorId, studentId) => {
    try {
      const { error } = await supabase
        .from('monitor_students')
        .insert({ monitor_id: monitorId, student_id: studentId })

      if (error) throw error
      await fetchMonitorStudents(monitorId)
      fetchData() // Atualizar contagens e lista de disponíveis
      setShowAssignStudent(null)
      setAssignSearchTerm('')
    } catch (err) {
      console.error('Erro ao vincular aluno:', err)
      alert('Erro ao vincular aluno ao monitor.')
    }
  }

  const handleUnassignStudent = async (monitorId, studentId) => {
    try {
      await supabase
        .from('monitor_students')
        .delete()
        .eq('monitor_id', monitorId)
        .eq('student_id', studentId)

      await fetchMonitorStudents(monitorId)
      fetchData()
    } catch (err) {
      console.error('Erro ao desvincular aluno:', err)
      alert('Erro ao desvincular aluno.')
    }
  }

  // Usuários que podem ser promovidos a monitor (não são admin nem já são monitor)
  const promotableUsers = allUsers.filter(u => {
    const isAlreadyMonitor = monitors.some(m => m.id === u.id)
    const term = searchTerm.toLowerCase()
    const matchesSearch = !term ||
      (u.full_name || '').toLowerCase().includes(term) ||
      (u.email || '').toLowerCase().includes(term)
    return !isAlreadyMonitor && matchesSearch
  })

  // Alunos que podem ser vinculados (não vinculados ao monitor expandido)
  const getAssignableStudents = (monitorId) => {
    const currentStudents = monitorStudents[monitorId] || []
    const currentIds = new Set(currentStudents.map(s => s.id))
    const term = assignSearchTerm.toLowerCase()

    // Inclui todos os alunos disponíveis + alunos que estão vinculados a outros monitores
    return allUsers.filter(u => {
      if (currentIds.has(u.id)) return false
      if (monitors.some(m => m.id === u.id)) return false // Não vincular monitor como aluno
      const matchesSearch = !term ||
        (u.full_name || '').toLowerCase().includes(term) ||
        (u.email || '').toLowerCase().includes(term)
      return matchesSearch
    })
  }

  if (loading) {
    return (
      <div className="admin-monitors-page">
        <div className="loading-screen">
          <div className="spinner"></div>
          <p>Carregando...</p>
        </div>
      </div>
    )
  }

  return (
    <div className="admin-monitors-page">
      <div className="page-header">
        <div>
          <h1>👨‍🏫 Gerenciar Monitores</h1>
          <p>Defina monitores e vincule alunos a eles</p>
        </div>
        <button className="btn-primary" onClick={() => setShowAddMonitor(!showAddMonitor)}>
          <FiPlus /> Adicionar Monitor
        </button>
      </div>

      {/* Modal/Card para adicionar monitor */}
      {showAddMonitor && (
        <div className="add-monitor-card">
          <h3>Selecione um usuário para promover a Monitor</h3>
          <div className="search-bar">
            <FiSearch />
            <input
              type="text"
              placeholder="Buscar usuário por nome ou email..."
              value={searchTerm}
              onChange={e => setSearchTerm(e.target.value)}
            />
          </div>
          <div className="user-select-list">
            {promotableUsers.slice(0, 10).map(user => (
              <div key={user.id} className="user-select-item">
                <div className="user-select-info">
                  <span className="user-avatar-sm">
                    {(user.full_name || user.email || '?')[0].toUpperCase()}
                  </span>
                  <div>
                    <span className="user-select-name">{user.full_name || user.email}</span>
                    <span className="user-select-email">{user.email}</span>
                  </div>
                </div>
                <button
                  className="btn-promote"
                  onClick={() => handlePromoteToMonitor(user.id)}
                >
                  <FiUserPlus /> Monitor
                </button>
              </div>
            ))}
            {promotableUsers.length === 0 && (
              <p className="empty-text">Nenhum usuário encontrado.</p>
            )}
          </div>
          <button className="btn-cancel" onClick={() => { setShowAddMonitor(false); setSearchTerm('') }}>
            Cancelar
          </button>
        </div>
      )}

      {/* Lista de Monitores */}
      {monitors.length === 0 ? (
        <div className="empty-state">
          <FiUsers size={32} />
          <p>Nenhum monitor cadastrado.</p>
          <p className="help-text">Clique em "Adicionar Monitor" para começar.</p>
        </div>
      ) : (
        <div className="monitors-list">
          {monitors.map(monitor => {
            const isExpanded = expandedMonitor === monitor.id
            const students = monitorStudents[monitor.id] || []

            return (
              <div key={monitor.id} className="monitor-card">
                <div className="monitor-card-header" onClick={() => handleExpandMonitor(monitor.id)}>
                  <div className="monitor-info">
                    <span className="monitor-avatar">
                      {(monitor.full_name || monitor.email || '?')[0].toUpperCase()}
                    </span>
                    <div>
                      <span className="monitor-name">{monitor.full_name || monitor.email}</span>
                      <span className="monitor-email">{monitor.email}</span>
                    </div>
                  </div>
                  <div className="monitor-right">
                    <span className="student-count">{monitor.student_count} aluno{monitor.student_count !== 1 ? 's' : ''}</span>
                    {isExpanded ? <FiChevronUp /> : <FiChevronDown />}
                  </div>
                </div>

                {isExpanded && (
                  <div className="monitor-expanded">
                    <div className="monitor-actions-bar">
                      <button
                        className="btn-sm btn-assign"
                        onClick={(e) => { e.stopPropagation(); setShowAssignStudent(showAssignStudent === monitor.id ? null : monitor.id); setAssignSearchTerm('') }}
                      >
                        <FiUserPlus /> Vincular Aluno
                      </button>
                      <button
                        className="btn-sm btn-danger"
                        onClick={(e) => { e.stopPropagation(); handleRemoveMonitor(monitor.id) }}
                      >
                        <FiTrash2 /> Remover Monitor
                      </button>
                    </div>

                    {/* Assign Student */}
                    {showAssignStudent === monitor.id && (
                      <div className="assign-student-panel">
                        <div className="search-bar compact">
                          <FiSearch />
                          <input
                            type="text"
                            placeholder="Buscar aluno..."
                            value={assignSearchTerm}
                            onChange={e => setAssignSearchTerm(e.target.value)}
                          />
                        </div>
                        <div className="user-select-list compact">
                          {getAssignableStudents(monitor.id).slice(0, 8).map(student => (
                            <div key={student.id} className="user-select-item compact">
                              <div className="user-select-info">
                                <span className="user-avatar-xs">
                                  {(student.full_name || student.email || '?')[0].toUpperCase()}
                                </span>
                                <span className="user-select-name-sm">{student.full_name || student.email}</span>
                              </div>
                              <button
                                className="btn-xs btn-assign"
                                onClick={() => handleAssignStudent(monitor.id, student.id)}
                              >
                                +
                              </button>
                            </div>
                          ))}
                          {getAssignableStudents(monitor.id).length === 0 && (
                            <p className="empty-text">Nenhum aluno disponível.</p>
                          )}
                        </div>
                      </div>
                    )}

                    {/* Students list */}
                    <div className="monitor-students-section">
                      <h4>Alunos Vinculados ({students.length})</h4>
                      {students.length === 0 ? (
                        <p className="empty-text">Nenhum aluno vinculado.</p>
                      ) : (
                        <div className="assigned-students-list">
                          {students.map(student => (
                            <div key={student.id} className="assigned-student-item">
                              <div className="user-select-info">
                                <span className="user-avatar-xs">
                                  {(student.full_name || student.email || '?')[0].toUpperCase()}
                                </span>
                                <div>
                                  <span className="user-select-name-sm">{student.full_name || student.email}</span>
                                  <span className="user-select-email-sm">{student.email}</span>
                                </div>
                              </div>
                              <button
                                className="btn-xs btn-remove"
                                onClick={() => handleUnassignStudent(monitor.id, student.id)}
                                title="Desvincular aluno"
                              >
                                <FiUserX />
                              </button>
                            </div>
                          ))}
                        </div>
                      )}
                    </div>
                  </div>
                )}
              </div>
            )
          })}
        </div>
      )}
    </div>
  )
}
