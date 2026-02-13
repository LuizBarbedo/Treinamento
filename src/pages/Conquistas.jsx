import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'
import { computeDisciplineBadges, countDisciplineBadges, getAllDisciplineBadges, BADGE_DEFS } from '../lib/badges'
import { Badge, DisciplineBadgeSection } from '../components/Badges'
import '../components/Badges.css'

export default function Conquistas() {
  const { user } = useAuth()
  const [disciplineData, setDisciplineData] = useState([])
  const [loading, setLoading] = useState(true)
  const [totalBadges, setTotalBadges] = useState(0)
  const [totalDiamond, setTotalDiamond] = useState(0)
  const [totalGold, setTotalGold] = useState(0)
  const [totalSilver, setTotalSilver] = useState(0)
  const [hasGlobalBadge, setHasGlobalBadge] = useState(false)
  const [ranking, setRanking] = useState([])
  const [loadingRanking, setLoadingRanking] = useState(true)

  useEffect(() => {
    fetchBadges()
    fetchRanking()
  }, [])

  const fetchBadges = async () => {
    // Buscar dados em paralelo
    const [discRes, lessonsRes, progressRes, quizResultsRes, finalResultsRes] = await Promise.all([
      supabase.from('disciplines').select('*').order('order_index'),
      supabase.from('lessons').select('*').order('order_index'),
      supabase.from('lesson_progress').select('lesson_id, discipline_id').eq('user_id', user.id),
      supabase.from('lesson_quiz_results').select('lesson_id, discipline_id, score, correct_answers, total_questions').eq('user_id', user.id),
      supabase.from('quiz_results').select('discipline_id, score, correct_answers, total_questions').eq('user_id', user.id),
    ])

    const disciplines = discRes.data || []
    const allLessons = lessonsRes.data || []
    const allProgress = progressRes.data || []
    const allQuizResults = quizResultsRes.data || []
    const allFinalResults = finalResultsRes.data || []

    let badgeCount = 0
    let diamondCount = 0
    let goldCount = 0
    let silverCount = 0
    let allDisciplinesCompleted = true

    const results = disciplines.map(disc => {
      const lessons = allLessons.filter(l => l.discipline_id === disc.id)
      const completedIds = new Set(allProgress.filter(p => p.discipline_id === disc.id).map(p => p.lesson_id))
      const quizResults = allQuizResults.filter(r => r.discipline_id === disc.id)
      const finalResult = allFinalResults.find(r => r.discipline_id === disc.id) || null

      const result = computeDisciplineBadges({
        lessons,
        completedLessonIds: completedIds,
        lessonQuizResults: quizResults,
        finalQuizResult: finalResult,
      })

      // Usar funções centralizadas
      const allBadges = getAllDisciplineBadges(result)
      const count = allBadges.length

      badgeCount += count
      diamondCount += allBadges.filter(b => b.tier === 'diamond').length
      goldCount += allBadges.filter(b => b.tier === 'gold').length
      silverCount += allBadges.filter(b => b.tier === 'silver').length

      // Verificar se disciplina está completa
      const discComplete = result.badges.some(b => b.id === 'discipline_complete')
      if (!discComplete) allDisciplinesCompleted = false

      return {
        discipline: disc,
        badges: allBadges,
        disciplineBadges: result.badges,
        lessonBadges: result.lessonBadges,
        completedCount: completedIds.size,
        totalLessons: lessons.length,
      }
    })

    // Badge global: completou todas as disciplinas
    if (disciplines.length > 0 && allDisciplinesCompleted) {
      badgeCount += 1
      diamondCount += 1
      setHasGlobalBadge(true)
    }

    setDisciplineData(results.filter(r => r.badges.length > 0))
    setTotalBadges(badgeCount)
    setTotalDiamond(diamondCount)
    setTotalGold(goldCount)
    setTotalSilver(silverCount)
    setLoading(false)
  }

  const fetchRanking = async () => {
    try {
      const { data, error } = await supabase.rpc('get_badge_ranking')
      if (!error && data) {
        setRanking(data)
      }
    } catch (e) {
      console.error('Erro ao carregar ranking:', e)
    }
    setLoadingRanking(false)
  }

  if (loading) {
    return <div className="loading-screen"><div className="spinner"></div></div>
  }

  const getMedalEmoji = (position) => {
    if (position === 0) return '🥇'
    if (position === 1) return '🥈'
    if (position === 2) return '🥉'
    return `${position + 1}º`
  }

  return (
    <div className="conquistas-page">
      <div className="conquistas-header">
        <h1>🏆 Minhas Conquistas</h1>
        <p>Acompanhe seus badges e progresso em todas as disciplinas.</p>
      </div>

      <div className="conquistas-stats">
        <div className="conquista-stat-card">
          <span className="conquista-stat-number">{totalBadges}</span>
          <span className="conquista-stat-label">Total de Badges</span>
        </div>
        <div className="conquista-stat-card">
          <span className="conquista-stat-number">💎 {totalDiamond}</span>
          <span className="conquista-stat-label">Diamante</span>
        </div>
        <div className="conquista-stat-card">
          <span className="conquista-stat-number">🥇 {totalGold}</span>
          <span className="conquista-stat-label">Ouro</span>
        </div>
        <div className="conquista-stat-card">
          <span className="conquista-stat-number">🥈 {totalSilver}</span>
          <span className="conquista-stat-label">Prata</span>
        </div>
      </div>

      {/* Badge global */}
      {hasGlobalBadge && (
        <div className="conquistas-global-badge">
          <Badge {...BADGE_DEFS.all_disciplines_complete} size="lg" />
          <p>Parabéns! Você completou todas as disciplinas da plataforma!</p>
        </div>
      )}

      {disciplineData.length === 0 && !hasGlobalBadge ? (
        <div className="conquistas-empty">
          <div className="conquistas-empty-icon">🎮</div>
          <p>Você ainda não conquistou nenhum badge.</p>
          <p>Complete aulas e quizzes para ganhar conquistas!</p>
          <Link to="/disciplinas" className="btn-see-all" style={{ display: 'inline-block', marginTop: '1rem' }}>
            Ver Disciplinas →
          </Link>
        </div>
      ) : (
        disciplineData.map(({ discipline, badges }) => (
          <DisciplineBadgeSection
            key={discipline.id}
            disciplineName={discipline.name}
            disciplineIcon={discipline.icon}
            badges={badges}
          />
        ))
      )}

      {/* Ranking de Alunos */}
      <div className="ranking-section">
        <div className="ranking-header">
          <h2>🏅 Ranking de Alunos</h2>
          <p>Os alunos com mais badges na plataforma</p>
        </div>

        {loadingRanking ? (
          <div className="ranking-loading">
            <div className="spinner"></div>
          </div>
        ) : ranking.length === 0 ? (
          <div className="ranking-empty">
            <p>Nenhum dado de ranking disponível ainda.</p>
          </div>
        ) : (
          <div className="ranking-table-wrapper">
            <table className="ranking-table">
              <thead>
                <tr>
                  <th className="ranking-col-pos">#</th>
                  <th className="ranking-col-name">Aluno</th>
                  <th className="ranking-col-badges">Badges</th>
                </tr>
              </thead>
              <tbody>
                {ranking.map((entry, index) => {
                  const isCurrentUser = entry.user_id === user.id
                  return (
                    <tr
                      key={entry.user_id}
                      className={`ranking-row ${isCurrentUser ? 'ranking-row-current' : ''} ${index < 3 ? 'ranking-row-top' : ''}`}
                    >
                      <td className="ranking-col-pos">
                        <span className={`ranking-medal ${index < 3 ? `ranking-medal-${index + 1}` : ''}`}>
                          {getMedalEmoji(index)}
                        </span>
                      </td>
                      <td className="ranking-col-name">
                        <span className="ranking-name">{entry.user_name}</span>
                        {isCurrentUser && <span className="ranking-you-tag">Você</span>}
                      </td>
                      <td className="ranking-col-badges">
                        <span className="ranking-badge-count">🏆 {entry.badge_count}</span>
                      </td>
                    </tr>
                  )
                })}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  )
}
