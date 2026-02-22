import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'
import { computeDisciplineBadges, countDisciplineBadges, getAllDisciplineBadges, BADGE_DEFS } from '../lib/badges'
import { Badge } from '../components/Badges'
import { FiLock, FiCheck } from 'react-icons/fi'
import { BooksStackIcon, TrendingUpIcon, MedalIcon, TrophyIcon } from '../components/Icons'
import './Dashboard.css'

export default function Dashboard() {
  const { user } = useAuth()
  const [stats, setStats] = useState({ total: 0, completed: 0, inProgress: 0, badges: 0 })
  const [disciplines, setDisciplines] = useState([])
  const [completedDisciplines, setCompletedDisciplines] = useState(new Set())
  const [recentBadges, setRecentBadges] = useState([])

  useEffect(() => {
    fetchData()
  }, [])

  const fetchData = async () => {
    // Buscar todos os dados em paralelo
    const [discRes, lessonsRes, progressRes, lessonProgressRes, quizResultsRes, finalResultsRes] = await Promise.all([
      supabase.from('disciplines').select('*').order('order_index'),
      supabase.from('lessons').select('*').order('order_index'),
      supabase.from('user_progress').select('discipline_id').eq('user_id', user.id).eq('completed', true),
      supabase.from('lesson_progress').select('lesson_id, discipline_id').eq('user_id', user.id),
      supabase.from('lesson_quiz_results').select('lesson_id, discipline_id, score, correct_answers, total_questions').eq('user_id', user.id),
      supabase.from('quiz_results').select('discipline_id, score, correct_answers, total_questions').eq('user_id', user.id),
    ])

    const allDiscs = discRes.data || []
    const allLessons = lessonsRes.data || []
    const completedProgress = progressRes.data || []
    const lessonProgress = lessonProgressRes.data || []
    const allQuizResults = quizResultsRes.data || []
    const allFinalResults = finalResultsRes.data || []

    setDisciplines(allDiscs)

    const completedIds = new Set(completedProgress.map(p => p.discipline_id))
    setCompletedDisciplines(completedIds)

    // Disciplinas em andamento
    const inProgressIds = new Set()
    lessonProgress.forEach(lp => {
      if (!completedIds.has(lp.discipline_id)) {
        inProgressIds.add(lp.discipline_id)
      }
    })

    // Computar badges por disciplina
    let totalBadgeCount = 0
    const allBadges = []
    let allDisciplinesCompleted = true

    allDiscs.forEach(disc => {
      const lessons = allLessons.filter(l => l.discipline_id === disc.id)
      const completedLessonIds = new Set(lessonProgress.filter(p => p.discipline_id === disc.id).map(p => p.lesson_id))
      const quizResults = allQuizResults.filter(r => r.discipline_id === disc.id)
      const finalResult = allFinalResults.find(r => r.discipline_id === disc.id) || null

      const result = computeDisciplineBadges({
        lessons,
        completedLessonIds,
        lessonQuizResults: quizResults,
        finalQuizResult: finalResult,
      })

      // Usar a função centralizada de contagem
      totalBadgeCount += countDisciplineBadges(result)

      // Verificar se disciplina está completa
      const discComplete = result.badges.some(b => b.id === 'discipline_complete')
      if (!discComplete) allDisciplinesCompleted = false

      // Coletar todos os badges para exibir na seção de conquistas
      const discBadges = getAllDisciplineBadges(result)
      discBadges.forEach(b => {
        allBadges.push({ ...b, disciplineName: disc.name })
      })
    })

    // Badge global: completou todas as disciplinas
    if (allDiscs.length > 0 && allDisciplinesCompleted) {
      totalBadgeCount += 1
      allBadges.push({ ...BADGE_DEFS.all_disciplines_complete })
    }

    // Pegar badges mais notáveis (diamond e gold primeiro)
    const tierOrder = { diamond: 0, gold: 1, silver: 2, bronze: 3 }
    allBadges.sort((a, b) => (tierOrder[a.tier] || 3) - (tierOrder[b.tier] || 3))
    setRecentBadges(allBadges.slice(0, 6))

    setStats({
      total: allDiscs.length,
      completed: completedIds.size,
      inProgress: inProgressIds.size,
      badges: totalBadgeCount,
    })
  }

  const displayName = user?.user_metadata?.full_name || user?.email?.split('@')[0] || 'Usuário'

  const isDisciplineAccessible = (index) => {
    if (index === 0) return true
    return completedDisciplines.has(disciplines[index - 1].id)
  }

  return (
    <div className="dashboard">
      <div className="dashboard-welcome">
        <h1>Olá, {displayName}! 👋</h1>
        <p>Bem-vindo à plataforma de treinamento. Continue seus estudos de onde parou.</p>
      </div>

      <div className="stats-grid">
        <div className="stat-card">
          <BooksStackIcon size={22} className="stat-icon" />
          <div>
            <span className="stat-number">{stats.total}</span>
            <span className="stat-label">Disciplinas</span>
          </div>
        </div>
        <div className="stat-card">
          <TrendingUpIcon size={22} className="stat-icon" />
          <div>
            <span className="stat-number">{stats.inProgress}</span>
            <span className="stat-label">Em Andamento</span>
          </div>
        </div>
        <div className="stat-card">
          <MedalIcon size={22} className="stat-icon" />
          <div>
            <span className="stat-number">{stats.completed}</span>
            <span className="stat-label">Concluídas</span>
          </div>
        </div>
        <div className="stat-card stat-card-badges">
          <TrophyIcon size={22} className="stat-icon" />
          <div>
            <span className="stat-number">{stats.badges}</span>
            <span className="stat-label">Badges</span>
          </div>
        </div>
      </div>

      {/* Seção de Conquistas Recentes */}
      <div className="section dashboard-badges-section">
        <div className="section-header">
          <h2>🏅 Conquistas</h2>
          <Link to="/conquistas" className="btn-see-all">Ver todas →</Link>
        </div>
        {recentBadges.length > 0 ? (
          <div className="dashboard-badges-preview">
            {recentBadges.map((badge, i) => (
              <Badge key={`${badge.id}-${i}`} {...badge} size="md" />
            ))}
          </div>
        ) : (
          <div className="dashboard-badges-empty">
            <p>🎮 Complete aulas e quizzes para ganhar badges!</p>
          </div>
        )}
      </div>

      <div className="section">
        <div className="section-header">
          <h2>Disciplinas Disponíveis</h2>
          <Link to="/disciplinas" className="btn-see-all">Ver todas →</Link>
        </div>

        <div className="disciplines-grid">
          {disciplines.slice(0, 4).map((disc, index) => {
            const accessible = isDisciplineAccessible(index)
            const isCompleted = completedDisciplines.has(disc.id)

            if (!accessible) {
              return (
                <div key={disc.id} className="discipline-card discipline-card-locked">
                  <div className="discipline-emoji">{disc.icon || '📚'}</div>
                  <h3>{disc.name}</h3>
                  <p>{disc.description}</p>
                  <span className="card-locked-badge"><FiLock /> Bloqueada</span>
                </div>
              )
            }

            return (
              <Link key={disc.id} to={`/disciplinas/${disc.id}`} className={`discipline-card ${isCompleted ? 'discipline-card-completed' : ''}`}>
                <div className="discipline-emoji">{disc.icon || '📚'}</div>
                <h3>{disc.name}</h3>
                <p>{disc.description}</p>
                {isCompleted && <span className="card-completed-badge"><FiCheck /> Concluída</span>}
              </Link>
            )
          })}

          {disciplines.length === 0 && (
            <div className="empty-state">
              <p>Nenhuma disciplina disponível ainda.</p>
              <p className="empty-hint">As disciplinas serão adicionadas pelo administrador.</p>
            </div>
          )}
        </div>
      </div>
    </div>
  )
}
