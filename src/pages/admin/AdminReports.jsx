import { useEffect, useState } from 'react'
import * as XLSX from 'xlsx'
import { supabase } from '../../lib/supabase'
import { FiUsers, FiBook, FiAward, FiTrendingUp, FiChevronDown, FiChevronUp, FiBarChart2, FiCheckCircle, FiClock, FiPercent, FiDownload } from 'react-icons/fi'
import './AdminReports.css'

export default function AdminReports() {
  const [loading, setLoading] = useState(true)
  const [stats, setStats] = useState(null)
  const [users, setUsers] = useState([])
  const [disciplines, setDisciplines] = useState([])
  const [allProgress, setAllProgress] = useState([])
  const [allQuizResults, setAllQuizResults] = useState([])
  const [allLessonProgress, setAllLessonProgress] = useState([])
  const [allLessonQuizResults, setAllLessonQuizResults] = useState([])
  // Monitoria: vínculos, dúvidas e mensagens alimentam as abas de interação
  // aluno-monitor da exportação. Ficam vazios enquanto ninguém abrir dúvida.
  const [monitorLinks, setMonitorLinks] = useState([])
  const [doubts, setDoubts] = useState([])
  const [doubtReplies, setDoubtReplies] = useState([])
  const [expandedUser, setExpandedUser] = useState(null)
  const [activeTab, setActiveTab] = useState('overview')
  const [searchTerm, setSearchTerm] = useState('')

  useEffect(() => {
    fetchAllData()
  }, [])

  const fetchAllData = async () => {
    try {
      const [
        { data: platformStats },
        { data: platformUsers },
        { data: discs },
        { data: progress },
        { data: quizResults },
        { data: lessonProg },
        { data: lessonQuiz },
        { data: lessons },
        { data: links },
        { data: doubtRows },
        { data: replyRows }
      ] = await Promise.all([
        supabase.rpc('get_platform_stats'),
        supabase.rpc('get_platform_users'),
        supabase.from('disciplines').select('*').order('order_index'),
        supabase.from('user_progress').select('*'),
        supabase.from('quiz_results').select('*'),
        supabase.from('lesson_progress').select('*'),
        supabase.from('lesson_quiz_results').select('*'),
        supabase.from('lessons').select('*').order('order_index'),
        supabase.from('monitor_students').select('*'),
        supabase.from('doubts').select('*').order('created_at'),
        supabase.from('doubt_replies').select('*').order('created_at')
      ])

      setStats(platformStats)
      setUsers(platformUsers || [])
      setDisciplines((discs || []).map(d => ({
        ...d,
        lessons: (lessons || []).filter(l => l.discipline_id === d.id)
      })))
      setAllProgress(progress || [])
      setAllQuizResults(quizResults || [])
      setAllLessonProgress(lessonProg || [])
      setAllLessonQuizResults(lessonQuiz || [])
      setMonitorLinks(links || [])
      setDoubts(doubtRows || [])
      setDoubtReplies(replyRows || [])
    } catch (err) {
      console.error('Erro ao buscar dados do relatório:', err)
    } finally {
      setLoading(false)
    }
  }

  // Métricas por disciplina
  const getDisciplineMetrics = (disciplineId) => {
    const disc = disciplines.find(d => d.id === disciplineId)
    const totalLessons = disc?.lessons?.length || 0

    const enrolledUsers = new Set([
      ...allLessonProgress.filter(lp => lp.discipline_id === disciplineId).map(lp => lp.user_id),
      ...allQuizResults.filter(qr => qr.discipline_id === disciplineId).map(qr => qr.user_id),
      ...allProgress.filter(p => p.discipline_id === disciplineId).map(p => p.user_id),
      ...allLessonQuizResults.filter(lq => lq.discipline_id === disciplineId).map(lq => lq.user_id)
    ])

    const completedUsers = allProgress.filter(
      p => p.discipline_id === disciplineId && p.completed
    )

    const quizScores = allQuizResults.filter(qr => qr.discipline_id === disciplineId)
    const avgScore = quizScores.length > 0
      ? Math.round(quizScores.reduce((sum, qr) => sum + (qr.score || 0), 0) / quizScores.length)
      : null

    const passRate = quizScores.length > 0
      ? Math.round((quizScores.filter(qr => qr.score >= 70).length / quizScores.length) * 100)
      : null

    return {
      enrolled: enrolledUsers.size,
      completed: completedUsers.length,
      totalLessons,
      avgScore,
      passRate,
      quizAttempts: quizScores.length
    }
  }

  // Métricas por usuário
  const getUserMetrics = (userId) => {
    const userProgressItems = allProgress.filter(p => p.user_id === userId)
    const userQuizResults = allQuizResults.filter(qr => qr.user_id === userId)
    const userLessonProg = allLessonProgress.filter(lp => lp.user_id === userId)
    const userLessonQuiz = allLessonQuizResults.filter(lq => lq.user_id === userId)

    const completedDiscs = userProgressItems.filter(p => p.completed).length

    // Progresso geral do aluno: disciplinas concluídas em relação ao total da plataforma
    const overallProgress = disciplines.length > 0
      ? Math.round((completedDiscs / disciplines.length) * 100)
      : 0

    // Disciplinas em andamento: qualquer atividade (aula, quiz de aula ou quiz final)
    // em uma disciplina que ainda não foi concluída.
    const inProgressDiscIds = new Set()
    const completedDiscIds = new Set(userProgressItems.filter(p => p.completed).map(p => p.discipline_id))
    userLessonProg.forEach(lp => {
      if (!completedDiscIds.has(lp.discipline_id)) {
        inProgressDiscIds.add(lp.discipline_id)
      }
    })
    userLessonQuiz.forEach(lq => {
      if (!completedDiscIds.has(lq.discipline_id)) {
        inProgressDiscIds.add(lq.discipline_id)
      }
    })
    userQuizResults.forEach(qr => {
      if (!completedDiscIds.has(qr.discipline_id)) {
        inProgressDiscIds.add(qr.discipline_id)
      }
    })

    const avgQuizScore = userQuizResults.length > 0
      ? Math.round(userQuizResults.reduce((sum, qr) => sum + (qr.score || 0), 0) / userQuizResults.length)
      : null

    const totalLessonsCompleted = userLessonProg.length

    return {
      completedDiscs,
      inProgressDiscs: inProgressDiscIds.size,
      overallProgress,
      avgQuizScore,
      totalLessonsCompleted,
      quizAttempts: userQuizResults.length,
      lessonQuizAttempts: userLessonQuiz.length,
      details: {
        progress: userProgressItems,
        quizResults: userQuizResults,
        lessonProgress: userLessonProg,
        lessonQuizResults: userLessonQuiz
      }
    }
  }

  // Progresso detalhado de um usuário por disciplina
  const getUserDisciplineDetail = (userId, disciplineId) => {
    const disc = disciplines.find(d => d.id === disciplineId)
    const totalLessons = disc?.lessons?.length || 0

    const lessonsCompleted = allLessonProgress.filter(
      lp => lp.user_id === userId && lp.discipline_id === disciplineId
    ).length

    const quizResult = allQuizResults.find(
      qr => qr.user_id === userId && qr.discipline_id === disciplineId
    )

    const lessonQuizzes = allLessonQuizResults.filter(
      lq => lq.user_id === userId && lq.discipline_id === disciplineId
    )

    const completed = allProgress.find(
      p => p.user_id === userId && p.discipline_id === disciplineId && p.completed
    )

    // Se a disciplina está marcada como concluída, mostra 100%
    // (cobre casos antigos do bug onde o aluno passou no quiz final sem ter lesson_progress).
    // Caso contrário, calcula com base nas aulas concluídas.
    const progressPercent = completed
      ? 100
      : totalLessons > 0
        ? Math.round((lessonsCompleted / totalLessons) * 100)
        : 0

    return {
      disciplineName: disc?.name || 'Desconhecida',
      disciplineIcon: disc?.icon || '📚',
      totalLessons,
      lessonsCompleted,
      progressPercent,
      quizScore: quizResult?.score ?? null,
      quizTotal: quizResult?.total_questions ?? null,
      quizCorrect: quizResult?.correct_answers ?? null,
      lessonQuizzes,
      completed: !!completed,
      completedAt: completed?.completed_at || quizResult?.completed_at
    }
  }

  const filteredUsers = users.filter(u => {
    const term = searchTerm.toLowerCase()
    return (
      (u.full_name || '').toLowerCase().includes(term) ||
      (u.email || '').toLowerCase().includes(term)
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

  // ---------------------------------------------------------------------
  // Monitoria: consolida a interação entre aluno e monitor.
  // Funciona com a base vazia — as abas saem só com os cabeçalhos e com os
  // vínculos já formados, e passam a se preencher assim que houver dúvidas.
  // ---------------------------------------------------------------------
  const STATUS_DUVIDA = {
    open: 'Aguardando resposta',
    answered: 'Respondida',
    resolved: 'Resolvida'
  }

  const horasEntre = (inicio, fim) => (new Date(fim) - new Date(inicio)) / 3600000

  const mediaHoras = (valores) => {
    if (valores.length === 0) return null
    return Math.round((valores.reduce((s, v) => s + v, 0) / valores.length) * 10) / 10
  }

  const maiorData = (datas) => {
    const validas = datas.filter(Boolean)
    if (validas.length === 0) return null
    return validas.reduce((a, b) => (new Date(a) > new Date(b) ? a : b))
  }

  // Classificação equivalente à do Relatório de Monitores
  const classificarMonitor = (recebidas, pendentes, horasMedia) => {
    if (recebidas === 0) return 'Sem atividade'
    const taxaPendente = pendentes / recebidas
    if (taxaPendente > 0.5) return 'Atenção'
    if (horasMedia !== null && horasMedia > 48) return 'Lento'
    if (taxaPendente <= 0.1 && (horasMedia === null || horasMedia <= 24)) return 'Excelente'
    return 'Bom'
  }

  const buildMonitoriaRows = (dataset) => {
    const noRecorte = new Set(dataset.map(u => u.id))
    const usuarioPorId = new Map(users.map(u => [u.id, u]))
    const disciplinaPorId = new Map(disciplines.map(d => [d.id, d]))
    const aulaPorId = new Map(
      disciplines.flatMap(d => (d.lessons || []).map(l => [l.id, l]))
    )

    const nomeDe = (id) => usuarioPorId.get(id)?.full_name || usuarioPorId.get(id)?.email || ''
    const emailDe = (id) => usuarioPorId.get(id)?.email || ''

    const vinculos = monitorLinks.filter(v => noRecorte.has(v.student_id))
    const monitorDoAluno = new Map(vinculos.map(v => [v.student_id, v]))

    // Mensagens agrupadas por dúvida, em ordem cronológica
    const respostasPorDuvida = new Map()
    doubtReplies.forEach(r => {
      const lista = respostasPorDuvida.get(r.doubt_id) || []
      lista.push(r)
      respostasPorDuvida.set(r.doubt_id, lista)
    })
    respostasPorDuvida.forEach(lista =>
      lista.sort((a, b) => new Date(a.created_at) - new Date(b.created_at))
    )

    // Dados derivados de cada dúvida, reaproveitados nas três abas
    const duvidasDoRecorte = doubts.filter(d => monitorDoAluno.has(d.user_id))
    const analiseDuvida = new Map()
    duvidasDoRecorte.forEach(d => {
      const mensagens = respostasPorDuvida.get(d.id) || []
      const doAluno = mensagens.filter(m => m.user_id === d.user_id)
      const doMonitor = mensagens.filter(m => m.user_id !== d.user_id)
      const primeiraResposta = doMonitor[0] || null
      analiseDuvida.set(d.id, {
        mensagens,
        doAluno,
        doMonitor,
        primeiraResposta,
        horasAteResposta: primeiraResposta
          ? Math.round(horasEntre(d.created_at, primeiraResposta.created_at) * 10) / 10
          : null,
        ultimaMensagem: mensagens.length > 0 ? mensagens[mensagens.length - 1].created_at : null
      })
    })

    // ---------------- aba por aluno ----------------
    const alunos = vinculos
      .map(v => {
        const minhasDuvidas = duvidasDoRecorte.filter(d => d.user_id === v.student_id)
        const analises = minhasDuvidas.map(d => analiseDuvida.get(d.id))
        const abertas = minhasDuvidas.filter(d => d.status === 'open').length
        const respondidas = minhasDuvidas.filter(d => d.status === 'answered').length
        const resolvidas = minhasDuvidas.filter(d => d.status === 'resolved').length
        const tempos = analises.map(a => a.horasAteResposta).filter(h => h !== null)

        let situacao = 'Sem dúvidas registradas'
        if (minhasDuvidas.length > 0) {
          if (abertas > 0) situacao = 'Aguardando resposta'
          else if (respondidas > 0) situacao = 'Em andamento'
          else situacao = 'Atendimentos concluídos'
        }

        return {
          'Aluno': nomeDe(v.student_id),
          'E-mail do aluno': emailDe(v.student_id),
          'Monitor': nomeDe(v.monitor_id),
          'E-mail do monitor': emailDe(v.monitor_id),
          'Vinculado em': formatDate(v.assigned_at),
          'Último acesso do aluno': formatDate(usuarioPorId.get(v.student_id)?.last_sign_in_at),
          'Dúvidas enviadas': minhasDuvidas.length,
          'Aguardando resposta': abertas,
          'Respondidas': respondidas,
          'Resolvidas': resolvidas,
          'Mensagens do aluno': analises.reduce((s, a) => s + a.doAluno.length, 0),
          'Respostas do monitor': analises.reduce((s, a) => s + a.doMonitor.length, 0),
          'Primeira dúvida em': formatDateTime(minhasDuvidas[0]?.created_at),
          'Última interação em': formatDateTime(
            maiorData([
              ...minhasDuvidas.map(d => d.created_at),
              ...analises.map(a => a.ultimaMensagem)
            ])
          ),
          'Tempo médio até 1ª resposta (h)': mediaHoras(tempos) ?? '',
          'Situação': situacao
        }
      })
      .sort((a, b) => a['Aluno'].localeCompare(b['Aluno'], 'pt-BR'))

    // ---------------- aba por monitor ----------------
    const porMonitor = new Map()
    vinculos.forEach(v => {
      const grupo = porMonitor.get(v.monitor_id) || []
      grupo.push(v.student_id)
      porMonitor.set(v.monitor_id, grupo)
    })

    const monitores = Array.from(porMonitor.entries())
      .map(([monitorId, alunoIds]) => {
        const idsGrupo = new Set(alunoIds)
        const recebidas = duvidasDoRecorte.filter(d => idsGrupo.has(d.user_id))
        const analises = recebidas.map(d => analiseDuvida.get(d.id))
        const abertas = recebidas.filter(d => d.status === 'open').length
        const respondidas = recebidas.filter(d => d.status === 'answered').length
        const resolvidas = recebidas.filter(d => d.status === 'resolved').length
        const respostas = analises.flatMap(a => a.doMonitor)
        const tempos = analises.map(a => a.horasAteResposta).filter(h => h !== null)
        const horasMedia = mediaHoras(tempos)
        const datasRespostas = respostas.map(r => r.created_at).sort()

        return {
          'Monitor': nomeDe(monitorId),
          'E-mail do monitor': emailDe(monitorId),
          'Alunos vinculados': alunoIds.length,
          'Alunos que enviaram dúvida': new Set(recebidas.map(d => d.user_id)).size,
          'Dúvidas recebidas': recebidas.length,
          'Aguardando resposta': abertas,
          'Respondidas': respondidas,
          'Resolvidas': resolvidas,
          'Respostas enviadas': respostas.length,
          'Tempo médio até 1ª resposta (h)': horasMedia ?? '',
          'Primeira resposta em': formatDateTime(datasRespostas[0]),
          'Última resposta em': formatDateTime(datasRespostas[datasRespostas.length - 1]),
          'Taxa de resolução (%)': recebidas.length > 0
            ? Math.round(((respondidas + resolvidas) / recebidas.length) * 100)
            : '',
          'Situação': classificarMonitor(recebidas.length, abertas, horasMedia)
        }
      })
      .sort((a, b) => a['Monitor'].localeCompare(b['Monitor'], 'pt-BR'))

    // ---------------- aba por dúvida ----------------
    const duvidas = duvidasDoRecorte
      .map(d => {
        const a = analiseDuvida.get(d.id)
        const vinculo = monitorDoAluno.get(d.user_id)
        return {
          'Título da dúvida': d.title || '',
          'Aluno': nomeDe(d.user_id),
          'E-mail do aluno': emailDe(d.user_id),
          'Monitor': vinculo ? nomeDe(vinculo.monitor_id) : '',
          'Disciplina': disciplinaPorId.get(d.discipline_id)?.name || '',
          'Aula': aulaPorId.get(d.lesson_id)?.title || 'Dúvida geral da disciplina',
          'Status': STATUS_DUVIDA[d.status] || d.status || '',
          'Criada em': formatDateTime(d.created_at),
          'Total de mensagens': a.mensagens.length,
          'Mensagens do aluno': a.doAluno.length,
          'Respostas do monitor': a.doMonitor.length,
          'Primeira resposta em': formatDateTime(a.primeiraResposta?.created_at),
          'Tempo até 1ª resposta (h)': a.horasAteResposta ?? '',
          'Última mensagem em': formatDateTime(a.ultimaMensagem),
          'Última movimentação': formatDateTime(d.updated_at),
          'Descrição': d.description || ''
        }
      })
      .sort((a, b) => a['Aluno'].localeCompare(b['Aluno'], 'pt-BR'))

    return { alunos, monitores, duvidas }
  }

  // Monta a planilha a partir dos cabeçalhos, para que a aba saia com as
  // colunas mesmo quando ainda não há nenhuma linha de dados.
  const sheetComCabecalho = (headers, rows, widths) => {
    const matriz = [headers, ...rows.map(r => headers.map(h => r[h] ?? ''))]
    const ws = XLSX.utils.aoa_to_sheet(matriz)
    ws['!cols'] = widths.map(wch => ({ wch }))
    ws['!autofilter'] = {
      ref: XLSX.utils.encode_range({
        s: { r: 0, c: 0 },
        e: { r: Math.max(rows.length, 1), c: headers.length - 1 }
      })
    }
    return ws
  }

  const exportStudentsToExcel = () => {
    const dataset = filteredUsers.length > 0 ? filteredUsers : users

    const summaryRows = dataset.map(u => {
      const m = getUserMetrics(u.id)
      return {
        'Nome': u.full_name || '',
        'Email': u.email || '',
        'Cadastrado em': u.created_at ? new Date(u.created_at).toLocaleDateString('pt-BR') : '',
        'Último acesso': u.last_sign_in_at ? new Date(u.last_sign_in_at).toLocaleDateString('pt-BR') : '',
        'Disciplinas concluídas': m.completedDiscs,
        'Disciplinas em andamento': m.inProgressDiscs,
        'Total de disciplinas na plataforma': disciplines.length,
        'Progresso (%)': m.overallProgress,
        'Aulas concluídas': m.totalLessonsCompleted,
        'Quizzes finais realizados': m.quizAttempts,
        'Quizzes de aula realizados': m.lessonQuizAttempts,
        'Média do quiz final (%)': m.avgQuizScore ?? ''
      }
    })

    const detailRows = []
    dataset.forEach(u => {
      disciplines.forEach(disc => {
        const d = getUserDisciplineDetail(u.id, disc.id)
        const hasActivity = d.lessonsCompleted > 0 || d.quizScore !== null || d.lessonQuizzes.length > 0
        if (!hasActivity) return

        const lessonQuizzesPassed = d.lessonQuizzes.filter(lq => lq.passed).length
        const status = d.completed
          ? 'Concluída'
          : hasActivity
          ? 'Em andamento'
          : 'Não iniciada'

        detailRows.push({
          'Nome': u.full_name || '',
          'Email': u.email || '',
          'Disciplina': d.disciplineName,
          'Status': status,
          'Aulas concluídas': d.lessonsCompleted,
          'Total de aulas': d.totalLessons,
          'Progresso (%)': d.progressPercent,
          'Quizzes de aula aprovados': lessonQuizzesPassed,
          'Quizzes de aula realizados': d.lessonQuizzes.length,
          'Quiz final (%)': d.quizScore ?? '',
          'Quiz final - acertos': d.quizCorrect ?? '',
          'Quiz final - total questões': d.quizTotal ?? '',
          'Concluída em': d.completedAt ? new Date(d.completedAt).toLocaleString('pt-BR') : ''
        })
      })
    })

    const wb = XLSX.utils.book_new()
    const wsResumo = XLSX.utils.json_to_sheet(summaryRows)
    const wsDetalhado = XLSX.utils.json_to_sheet(detailRows)

    wsResumo['!cols'] = [
      { wch: 28 }, { wch: 32 }, { wch: 14 }, { wch: 14 },
      { wch: 14 }, { wch: 18 }, { wch: 18 }, { wch: 14 },
      { wch: 14 }, { wch: 18 }, { wch: 18 }, { wch: 18 }
    ]
    wsDetalhado['!cols'] = [
      { wch: 28 }, { wch: 32 }, { wch: 24 }, { wch: 14 },
      { wch: 14 }, { wch: 14 }, { wch: 14 }, { wch: 18 },
      { wch: 18 }, { wch: 14 }, { wch: 14 }, { wch: 14 }, { wch: 18 }
    ]

    XLSX.utils.book_append_sheet(wb, wsResumo, 'Resumo')
    XLSX.utils.book_append_sheet(wb, wsDetalhado, 'Detalhado')

    // Abas de monitoria: interação entre aluno e monitor
    const monitoria = buildMonitoriaRows(dataset)

    XLSX.utils.book_append_sheet(wb, sheetComCabecalho(
      [
        'Aluno', 'E-mail do aluno', 'Monitor', 'E-mail do monitor', 'Vinculado em',
        'Último acesso do aluno', 'Dúvidas enviadas', 'Aguardando resposta', 'Respondidas',
        'Resolvidas', 'Mensagens do aluno', 'Respostas do monitor', 'Primeira dúvida em',
        'Última interação em', 'Tempo médio até 1ª resposta (h)', 'Situação'
      ],
      monitoria.alunos,
      [28, 32, 28, 32, 14, 18, 16, 18, 14, 12, 18, 18, 18, 18, 26, 24]
    ), 'Monitoria - Alunos')

    XLSX.utils.book_append_sheet(wb, sheetComCabecalho(
      [
        'Monitor', 'E-mail do monitor', 'Alunos vinculados', 'Alunos que enviaram dúvida',
        'Dúvidas recebidas', 'Aguardando resposta', 'Respondidas', 'Resolvidas',
        'Respostas enviadas', 'Tempo médio até 1ª resposta (h)', 'Primeira resposta em',
        'Última resposta em', 'Taxa de resolução (%)', 'Situação'
      ],
      monitoria.monitores,
      [28, 32, 18, 26, 18, 18, 14, 12, 18, 26, 20, 20, 20, 16]
    ), 'Monitoria - Monitores')

    XLSX.utils.book_append_sheet(wb, sheetComCabecalho(
      [
        'Título da dúvida', 'Aluno', 'E-mail do aluno', 'Monitor', 'Disciplina', 'Aula',
        'Status', 'Criada em', 'Total de mensagens', 'Mensagens do aluno',
        'Respostas do monitor', 'Primeira resposta em', 'Tempo até 1ª resposta (h)',
        'Última mensagem em', 'Última movimentação', 'Descrição'
      ],
      monitoria.duvidas,
      [40, 28, 32, 28, 24, 28, 18, 18, 18, 18, 18, 20, 22, 20, 20, 60]
    ), 'Monitoria - Dúvidas')

    const today = new Date().toISOString().slice(0, 10)
    XLSX.writeFile(wb, `relatorio-alunos-${today}.xlsx`)
  }

  if (loading) {
    return (
      <div className="loading-screen">
        <div className="spinner"></div>
        <p>Carregando relatórios...</p>
      </div>
    )
  }

  return (
    <div className="admin-reports">
      <div className="admin-header">
        <div>
          <h1>📊 Relatório Geral</h1>
          <p className="admin-subtitle">Visão completa do progresso dos alunos na plataforma</p>
        </div>
      </div>

      {/* Overview Cards */}
      <div className="report-stats-grid">
        <div className="report-stat-card">
          <div className="report-stat-icon users"><FiUsers /></div>
          <div className="report-stat-info">
            <span className="report-stat-number">{stats?.total_users || 0}</span>
            <span className="report-stat-label">Usuários Cadastrados</span>
          </div>
        </div>
        <div className="report-stat-card">
          <div className="report-stat-icon disciplines"><FiBook /></div>
          <div className="report-stat-info">
            <span className="report-stat-number">{stats?.total_disciplines || 0}</span>
            <span className="report-stat-label">Disciplinas</span>
          </div>
        </div>
        <div className="report-stat-card">
          <div className="report-stat-icon completed"><FiCheckCircle /></div>
          <div className="report-stat-info">
            <span className="report-stat-number">{stats?.completed_disciplines || 0}</span>
            <span className="report-stat-label">Disciplinas Concluídas</span>
          </div>
        </div>
        <div className="report-stat-card">
          <div className="report-stat-icon score"><FiAward /></div>
          <div className="report-stat-info">
            <span className="report-stat-number">{stats?.avg_quiz_score || 0}%</span>
            <span className="report-stat-label">Média Geral (Quiz Final)</span>
          </div>
        </div>
        <div className="report-stat-card">
          <div className="report-stat-icon quizzes"><FiBarChart2 /></div>
          <div className="report-stat-info">
            <span className="report-stat-number">{stats?.quiz_attempts || 0}</span>
            <span className="report-stat-label">Quizzes Finais Realizados</span>
          </div>
        </div>
        <div className="report-stat-card">
          <div className="report-stat-icon lessons"><FiTrendingUp /></div>
          <div className="report-stat-info">
            <span className="report-stat-number">{stats?.total_lessons || 0}</span>
            <span className="report-stat-label">Aulas Disponíveis</span>
          </div>
        </div>
      </div>

      {/* Tabs */}
      <div className="report-tabs">
        <button
          className={`report-tab ${activeTab === 'overview' ? 'active' : ''}`}
          onClick={() => setActiveTab('overview')}
        >
          <FiBarChart2 /> Disciplinas
        </button>
        <button
          className={`report-tab ${activeTab === 'users' ? 'active' : ''}`}
          onClick={() => setActiveTab('users')}
        >
          <FiUsers /> Alunos
        </button>
      </div>

      {/* Tab: Disciplinas */}
      {activeTab === 'overview' && (
        <div className="report-section">
          <h2>Desempenho por Disciplina</h2>
          <div className="report-table">
            <div className="report-table-header">
              <span className="col-disc-icon"></span>
              <span className="col-disc-name">Disciplina</span>
              <span className="col-metric">Alunos</span>
              <span className="col-metric">Concluíram</span>
              <span className="col-metric">Aulas</span>
              <span className="col-metric">Média Quiz</span>
              <span className="col-metric">Aprovação</span>
            </div>
            {disciplines.map(disc => {
              const metrics = getDisciplineMetrics(disc.id)
              return (
                <div key={disc.id} className="report-table-row">
                  <span className="col-disc-icon">{disc.icon || '📚'}</span>
                  <div className="col-disc-name">
                    <strong>{disc.name}</strong>
                    <small>{disc.description}</small>
                  </div>
                  <span className="col-metric">
                    <span className="metric-value">{metrics.enrolled}</span>
                    <span className="metric-label">cursando</span>
                  </span>
                  <span className="col-metric">
                    <span className="metric-value">{metrics.completed}</span>
                    <span className="metric-label">alunos</span>
                  </span>
                  <span className="col-metric">
                    <span className="metric-value">{metrics.totalLessons}</span>
                    <span className="metric-label">aulas</span>
                  </span>
                  <span className="col-metric">
                    {metrics.avgScore !== null ? (
                      <>
                        <span className={`metric-value ${metrics.avgScore >= 70 ? 'good' : 'warn'}`}>
                          {metrics.avgScore}%
                        </span>
                        <span className="metric-label">{metrics.quizAttempts} tent.</span>
                      </>
                    ) : (
                      <span className="metric-empty">—</span>
                    )}
                  </span>
                  <span className="col-metric">
                    {metrics.passRate !== null ? (
                      <span className={`metric-value ${metrics.passRate >= 70 ? 'good' : 'warn'}`}>
                        {metrics.passRate}%
                      </span>
                    ) : (
                      <span className="metric-empty">—</span>
                    )}
                  </span>
                </div>
              )
            })}
            {disciplines.length === 0 && (
              <div className="report-table-empty">Nenhuma disciplina cadastrada.</div>
            )}
          </div>
        </div>
      )}

      {/* Tab: Alunos */}
      {activeTab === 'users' && (
        <div className="report-section">
          <div className="report-section-header">
            <h2>Progresso dos Alunos</h2>
            <div className="report-section-actions">
              <div className="report-search">
                <input
                  type="text"
                  placeholder="Buscar por nome ou email..."
                  value={searchTerm}
                  onChange={e => setSearchTerm(e.target.value)}
                />
              </div>
              <button
                type="button"
                className="report-export-btn"
                onClick={exportStudentsToExcel}
                disabled={users.length === 0}
                title="Exportar relatório de alunos para Excel"
              >
                <FiDownload /> Exportar Excel
              </button>
            </div>
          </div>

          <div className="report-table">
            <div className="report-table-header">
              <span className="col-user-name">Aluno</span>
              <span className="col-metric">Cadastro</span>
              <span className="col-metric">Último Acesso</span>
              <span className="col-metric">Concluídas</span>
              <span className="col-metric">Progresso</span>
              <span className="col-metric">Em Andamento</span>
              <span className="col-metric">Média Quiz</span>
              <span className="col-metric">Aulas</span>
              <span className="col-expand"></span>
            </div>

            {filteredUsers.map(u => {
              const metrics = getUserMetrics(u.id)
              const isExpanded = expandedUser === u.id

              return (
                <div key={u.id} className={`report-user-block ${isExpanded ? 'expanded' : ''}`}>
                  <div
                    className="report-table-row report-table-row-clickable"
                    onClick={() => setExpandedUser(isExpanded ? null : u.id)}
                  >
                    <div className="col-user-name">
                      <strong>{u.full_name || u.email}</strong>
                      <small>{u.email}</small>
                    </div>
                    <span className="col-metric">
                      <span className="metric-value-sm">{formatDate(u.created_at)}</span>
                    </span>
                    <span className="col-metric">
                      <span className="metric-value-sm">{formatDate(u.last_sign_in_at)}</span>
                    </span>
                    <span className="col-metric">
                      <span className="metric-value">{metrics.completedDiscs}</span>
                      <span className="metric-label">de {disciplines.length}</span>
                    </span>
                    <span className="col-metric">
                      <span className={`metric-value ${metrics.overallProgress >= 100 ? 'good' : ''}`}>
                        {metrics.overallProgress}%
                      </span>
                      <div className="mini-progress-bar">
                        <div
                          className="mini-progress-fill"
                          style={{ width: `${metrics.overallProgress}%` }}
                        />
                      </div>
                    </span>
                    <span className="col-metric">
                      <span className="metric-value">{metrics.inProgressDiscs}</span>
                    </span>
                    <span className="col-metric">
                      {metrics.avgQuizScore !== null ? (
                        <span className={`metric-value ${metrics.avgQuizScore >= 70 ? 'good' : 'warn'}`}>
                          {metrics.avgQuizScore}%
                        </span>
                      ) : (
                        <span className="metric-empty">—</span>
                      )}
                    </span>
                    <span className="col-metric">
                      <span className="metric-value">{metrics.totalLessonsCompleted}</span>
                    </span>
                    <span className="col-expand">
                      {isExpanded ? <FiChevronUp /> : <FiChevronDown />}
                    </span>
                  </div>

                  {isExpanded && (
                    <div className="user-detail-panel">
                      <h4>Detalhamento por Disciplina</h4>
                      <div className="user-detail-grid">
                        {disciplines.map(disc => {
                          const detail = getUserDisciplineDetail(u.id, disc.id)
                          const hasActivity = detail.lessonsCompleted > 0 || detail.quizScore !== null || detail.lessonQuizzes.length > 0

                          return (
                            <div
                              key={disc.id}
                              className={`user-disc-card ${detail.completed ? 'completed' : ''} ${!hasActivity ? 'inactive' : ''}`}
                            >
                              <div className="user-disc-header">
                                <span className="user-disc-icon">{detail.disciplineIcon}</span>
                                <div className="user-disc-title">
                                  <strong>{detail.disciplineName}</strong>
                                  {detail.completed && <span className="badge-completed">✓ Concluída</span>}
                                  {!detail.completed && hasActivity && <span className="badge-progress">Em andamento</span>}
                                  {!hasActivity && <span className="badge-inactive">Não iniciada</span>}
                                </div>
                              </div>

                              {hasActivity && (
                                <div className="user-disc-metrics">
                                  <div className="user-disc-metric">
                                    <FiBook />
                                    <span>Aulas: {detail.lessonsCompleted}/{detail.totalLessons}</span>
                                    <div className="mini-progress-bar">
                                      <div
                                        className="mini-progress-fill"
                                        style={{ width: `${detail.progressPercent}%` }}
                                      />
                                    </div>
                                    <span className="mini-progress-text">{detail.progressPercent}%</span>
                                  </div>

                                  {detail.lessonQuizzes.length > 0 && (
                                    <div className="user-disc-metric">
                                      <FiCheckCircle />
                                      <span>Quizzes de aula: {detail.lessonQuizzes.filter(lq => lq.passed).length}/{detail.lessonQuizzes.length} aprovados</span>
                                    </div>
                                  )}

                                  {detail.quizScore !== null && (
                                    <div className="user-disc-metric">
                                      <FiAward />
                                      <span>Quiz Final: {detail.quizCorrect}/{detail.quizTotal} ({detail.quizScore}%)</span>
                                      <span className={`score-badge ${detail.quizScore >= 70 ? 'pass' : 'fail'}`}>
                                        {detail.quizScore >= 70 ? 'Aprovado' : 'Reprovado'}
                                      </span>
                                    </div>
                                  )}

                                  {detail.completedAt && (
                                    <div className="user-disc-metric">
                                      <FiClock />
                                      <span>Concluído em: {formatDateTime(detail.completedAt)}</span>
                                    </div>
                                  )}
                                </div>
                              )}
                            </div>
                          )
                        })}
                      </div>
                    </div>
                  )}
                </div>
              )
            })}

            {filteredUsers.length === 0 && (
              <div className="report-table-empty">
                {searchTerm ? 'Nenhum aluno encontrado para esta busca.' : 'Nenhum usuário cadastrado.'}
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  )
}
