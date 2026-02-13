import { useEffect, useState } from 'react'
import { supabase } from '../../lib/supabase'
import {
  FiUsers, FiMessageCircle, FiCheckCircle, FiClock,
  FiAlertCircle, FiChevronDown, FiChevronUp, FiSearch,
  FiActivity, FiInbox, FiSend, FiTrendingUp
} from 'react-icons/fi'
import './AdminMonitorReports.css'

export default function AdminMonitorReports() {
  const [loading, setLoading] = useState(true)
  const [stats, setStats] = useState(null)
  const [monitors, setMonitors] = useState([])
  const [expandedMonitor, setExpandedMonitor] = useState(null)
  const [monitorDoubts, setMonitorDoubts] = useState({})
  const [searchTerm, setSearchTerm] = useState('')

  useEffect(() => {
    fetchData()
  }, [])

  const fetchData = async () => {
    try {
      const [statsRes, monitorsRes] = await Promise.all([
        supabase.rpc('get_monitor_overview_stats'),
        supabase.rpc('get_monitor_reports')
      ])

      setStats(statsRes.data)
      setMonitors(monitorsRes.data || [])
    } catch (err) {
      console.error('Erro ao buscar relatório de monitores:', err)
    } finally {
      setLoading(false)
    }
  }

  const fetchMonitorDoubts = async (monitorId) => {
    const { data } = await supabase.rpc('get_monitor_doubts_detail', { p_monitor_id: monitorId })
    setMonitorDoubts(prev => ({ ...prev, [monitorId]: data || [] }))
  }

  const handleExpand = async (monitorId) => {
    if (expandedMonitor === monitorId) {
      setExpandedMonitor(null)
      return
    }
    setExpandedMonitor(monitorId)
    if (!monitorDoubts[monitorId]) {
      await fetchMonitorDoubts(monitorId)
    }
  }

  const filteredMonitors = monitors.filter(m => {
    const term = searchTerm.toLowerCase()
    return (
      (m.monitor_name || '').toLowerCase().includes(term) ||
      (m.monitor_email || '').toLowerCase().includes(term)
    )
  })

  const formatDate = (dateStr) => {
    if (!dateStr) return '—'
    return new Date(dateStr).toLocaleDateString('pt-BR', {
      day: '2-digit',
      month: '2-digit',
      year: 'numeric'
    })
  }

  const formatDateTime = (dateStr) => {
    if (!dateStr) return '—'
    return new Date(dateStr).toLocaleDateString('pt-BR', {
      day: '2-digit',
      month: '2-digit',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    })
  }

  const formatHours = (hours) => {
    if (hours === null || hours === undefined) return '—'
    if (hours < 1) return `${Math.round(hours * 60)}min`
    if (hours < 24) return `${hours}h`
    return `${Math.round(hours / 24)}d ${Math.round(hours % 24)}h`
  }

  const getStatusBadge = (status) => {
    switch (status) {
      case 'open':
        return <span className="monitor-status-badge open">Pendente</span>
      case 'answered':
        return <span className="monitor-status-badge answered">Respondida</span>
      case 'resolved':
        return <span className="monitor-status-badge resolved">Resolvida</span>
      default:
        return <span className="monitor-status-badge">{status}</span>
    }
  }

  const getPerformanceLevel = (monitor) => {
    const { doubts_pending, total_doubts_received, avg_response_hours } = monitor
    if (total_doubts_received === 0) return { label: 'Sem atividade', className: 'neutral' }
    const pendingRate = doubts_pending / total_doubts_received
    if (pendingRate > 0.5) return { label: 'Atenção', className: 'warn' }
    if (avg_response_hours !== null && avg_response_hours > 48) return { label: 'Lento', className: 'warn' }
    if (pendingRate <= 0.1 && (avg_response_hours === null || avg_response_hours <= 24))
      return { label: 'Excelente', className: 'excellent' }
    return { label: 'Bom', className: 'good' }
  }

  if (loading) {
    return (
      <div className="loading-screen">
        <div className="spinner"></div>
        <p>Carregando relatório de monitores...</p>
      </div>
    )
  }

  return (
    <div className="admin-monitor-reports">
      <div className="admin-header">
        <div>
          <h1>📋 Relatório de Monitores</h1>
          <p className="admin-subtitle">Métricas detalhadas de desempenho dos monitores na plataforma</p>
        </div>
      </div>

      {/* Overview Cards */}
      <div className="monitor-report-stats-grid">
        <div className="monitor-report-stat-card">
          <div className="monitor-report-stat-icon monitors"><FiUsers /></div>
          <div className="monitor-report-stat-info">
            <span className="monitor-report-stat-number">{stats?.total_monitors || 0}</span>
            <span className="monitor-report-stat-label">Monitores Ativos</span>
          </div>
        </div>
        <div className="monitor-report-stat-card">
          <div className="monitor-report-stat-icon students"><FiUsers /></div>
          <div className="monitor-report-stat-info">
            <span className="monitor-report-stat-number">{stats?.total_students_assigned || 0}</span>
            <span className="monitor-report-stat-label">Alunos Vinculados</span>
          </div>
        </div>
        <div className="monitor-report-stat-card">
          <div className="monitor-report-stat-icon total"><FiInbox /></div>
          <div className="monitor-report-stat-info">
            <span className="monitor-report-stat-number">{stats?.total_doubts || 0}</span>
            <span className="monitor-report-stat-label">Total de Dúvidas</span>
          </div>
        </div>
        <div className="monitor-report-stat-card">
          <div className="monitor-report-stat-icon pending"><FiAlertCircle /></div>
          <div className="monitor-report-stat-info">
            <span className="monitor-report-stat-number">{stats?.total_doubts_open || 0}</span>
            <span className="monitor-report-stat-label">Pendentes</span>
          </div>
        </div>
        <div className="monitor-report-stat-card">
          <div className="monitor-report-stat-icon answered"><FiSend /></div>
          <div className="monitor-report-stat-info">
            <span className="monitor-report-stat-number">{stats?.total_doubts_answered || 0}</span>
            <span className="monitor-report-stat-label">Respondidas</span>
          </div>
        </div>
        <div className="monitor-report-stat-card">
          <div className="monitor-report-stat-icon resolved"><FiCheckCircle /></div>
          <div className="monitor-report-stat-info">
            <span className="monitor-report-stat-number">{stats?.total_doubts_resolved || 0}</span>
            <span className="monitor-report-stat-label">Resolvidas</span>
          </div>
        </div>
        <div className="monitor-report-stat-card">
          <div className="monitor-report-stat-icon replies"><FiMessageCircle /></div>
          <div className="monitor-report-stat-info">
            <span className="monitor-report-stat-number">{stats?.total_replies || 0}</span>
            <span className="monitor-report-stat-label">Respostas Enviadas</span>
          </div>
        </div>
        <div className="monitor-report-stat-card">
          <div className="monitor-report-stat-icon time"><FiClock /></div>
          <div className="monitor-report-stat-info">
            <span className="monitor-report-stat-number">{formatHours(stats?.avg_response_hours)}</span>
            <span className="monitor-report-stat-label">Tempo Médio Resposta</span>
          </div>
        </div>
      </div>

      {/* Monitor List */}
      <div className="monitor-report-section">
        <div className="monitor-report-section-header">
          <h2>Desempenho Individual dos Monitores</h2>
          <div className="monitor-report-search">
            <FiSearch />
            <input
              type="text"
              placeholder="Buscar por nome ou email..."
              value={searchTerm}
              onChange={e => setSearchTerm(e.target.value)}
            />
          </div>
        </div>

        <div className="monitor-report-table">
          <div className="monitor-report-table-header">
            <span className="col-monitor-name">Monitor</span>
            <span className="col-monitor-metric">Alunos</span>
            <span className="col-monitor-metric">Dúvidas</span>
            <span className="col-monitor-metric">Pendentes</span>
            <span className="col-monitor-metric">Respondidas</span>
            <span className="col-monitor-metric">Resolvidas</span>
            <span className="col-monitor-metric">Tempo Médio</span>
            <span className="col-monitor-metric">Último Acesso</span>
            <span className="col-monitor-metric">Status</span>
            <span className="col-monitor-expand"></span>
          </div>

          {filteredMonitors.map(m => {
            const isExpanded = expandedMonitor === m.monitor_id
            const perf = getPerformanceLevel(m)
            const doubts = monitorDoubts[m.monitor_id] || []

            return (
              <div key={m.monitor_id} className={`monitor-report-user-block ${isExpanded ? 'expanded' : ''}`}>
                <div
                  className="monitor-report-table-row monitor-report-table-row-clickable"
                  onClick={() => handleExpand(m.monitor_id)}
                >
                  <div className="col-monitor-name">
                    <strong>{m.monitor_name}</strong>
                    <small>{m.monitor_email}</small>
                  </div>
                  <span className="col-monitor-metric">
                    <span className="monitor-metric-value">{m.total_students}</span>
                    <span className="monitor-metric-label">alunos</span>
                  </span>
                  <span className="col-monitor-metric">
                    <span className="monitor-metric-value">{m.total_doubts_received}</span>
                    <span className="monitor-metric-label">recebidas</span>
                  </span>
                  <span className="col-monitor-metric">
                    <span className={`monitor-metric-value ${m.doubts_pending > 0 ? 'warn' : 'good'}`}>
                      {m.doubts_pending}
                    </span>
                    <span className="monitor-metric-label">pendentes</span>
                  </span>
                  <span className="col-monitor-metric">
                    <span className="monitor-metric-value">{m.doubts_answered}</span>
                    <span className="monitor-metric-label">respondidas</span>
                  </span>
                  <span className="col-monitor-metric">
                    <span className="monitor-metric-value good">{m.doubts_resolved}</span>
                    <span className="monitor-metric-label">resolvidas</span>
                  </span>
                  <span className="col-monitor-metric">
                    <span className="monitor-metric-value">{formatHours(m.avg_response_hours)}</span>
                    <span className="monitor-metric-label">média</span>
                  </span>
                  <span className="col-monitor-metric">
                    <span className="monitor-metric-value-sm">{formatDateTime(m.last_sign_in_at)}</span>
                  </span>
                  <span className="col-monitor-metric">
                    <span className={`monitor-performance-badge ${perf.className}`}>{perf.label}</span>
                  </span>
                  <span className="col-monitor-expand">
                    {isExpanded ? <FiChevronUp /> : <FiChevronDown />}
                  </span>
                </div>

                {isExpanded && (
                  <div className="monitor-detail-panel">
                    {/* Monitor Summary Cards */}
                    <div className="monitor-detail-summary">
                      <div className="monitor-detail-card">
                        <FiActivity />
                        <div>
                          <strong>Primeira Resposta</strong>
                          <span>{formatDateTime(m.first_reply_at)}</span>
                        </div>
                      </div>
                      <div className="monitor-detail-card">
                        <FiClock />
                        <div>
                          <strong>Última Resposta</strong>
                          <span>{formatDateTime(m.last_reply_at)}</span>
                        </div>
                      </div>
                      <div className="monitor-detail-card">
                        <FiSend />
                        <div>
                          <strong>Total de Respostas</strong>
                          <span>{m.total_replies} mensagens</span>
                        </div>
                      </div>
                      <div className="monitor-detail-card">
                        <FiTrendingUp />
                        <div>
                          <strong>Taxa de Resolução</strong>
                          <span>
                            {m.total_doubts_received > 0
                              ? Math.round(((Number(m.doubts_answered) + Number(m.doubts_resolved)) / m.total_doubts_received) * 100)
                              : 0
                            }%
                          </span>
                        </div>
                      </div>
                    </div>

                    {/* Doubt List */}
                    <h4>Histórico de Dúvidas</h4>
                    {doubts.length > 0 ? (
                      <div className="monitor-doubts-list">
                        <div className="monitor-doubts-header">
                          <span className="col-doubt-student">Aluno</span>
                          <span className="col-doubt-discipline">Disciplina</span>
                          <span className="col-doubt-title">Título</span>
                          <span className="col-doubt-status">Status</span>
                          <span className="col-doubt-date">Data</span>
                          <span className="col-doubt-replies">Respostas</span>
                        </div>
                        {doubts.map(d => (
                          <div key={d.doubt_id} className="monitor-doubt-row">
                            <div className="col-doubt-student">
                              <strong>{d.student_name}</strong>
                              <small>{d.student_email}</small>
                            </div>
                            <span className="col-doubt-discipline">{d.discipline_name}</span>
                            <span className="col-doubt-title">{d.doubt_title}</span>
                            <span className="col-doubt-status">{getStatusBadge(d.doubt_status)}</span>
                            <span className="col-doubt-date">{formatDate(d.doubt_created_at)}</span>
                            <span className="col-doubt-replies">
                              {d.reply_count > 0 ? (
                                <span className="monitor-reply-count">{d.reply_count}</span>
                              ) : (
                                <span className="monitor-no-reply">0</span>
                              )}
                            </span>
                          </div>
                        ))}
                      </div>
                    ) : (
                      <p className="monitor-no-doubts">Nenhuma dúvida registrada para este monitor.</p>
                    )}
                  </div>
                )}
              </div>
            )
          })}

          {filteredMonitors.length === 0 && (
            <div className="monitor-report-table-empty">
              {searchTerm ? 'Nenhum monitor encontrado para esta busca.' : 'Nenhum monitor cadastrado.'}
            </div>
          )}
        </div>
      </div>
    </div>
  )
}
