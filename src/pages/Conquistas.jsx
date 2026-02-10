import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'
import { computeDisciplineBadges, BADGE_DEFS } from '../lib/badges'
import { Badge, DisciplineBadgeSection } from '../components/Badges'
import '../components/Badges.css'

export default function Conquistas() {
  const { user } = useAuth()
  const [disciplineData, setDisciplineData] = useState([])
  const [loading, setLoading] = useState(true)
  const [totalBadges, setTotalBadges] = useState(0)
  const [totalDiamond, setTotalDiamond] = useState(0)
  const [totalGold, setTotalGold] = useState(0)

  useEffect(() => {
    fetchBadges()
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

    const results = disciplines.map(disc => {
      const lessons = allLessons.filter(l => l.discipline_id === disc.id)
      const completedIds = new Set(allProgress.filter(p => p.discipline_id === disc.id).map(p => p.lesson_id))
      const quizResults = allQuizResults.filter(r => r.discipline_id === disc.id)
      const finalResult = allFinalResults.find(r => r.discipline_id === disc.id) || null

      const { badges, perfectLessonIds, lessonBadges } = computeDisciplineBadges({
        lessons,
        completedLessonIds: completedIds,
        lessonQuizResults: quizResults,
        finalQuizResult: finalResult,
      })

      // Aggregate all badges: discipline-level + lesson-level
      const allBadges = [...badges]
      lessonBadges.forEach((lb) => {
        allBadges.push(...lb)
      })

      // Also add lesson_complete badges for completed lessons without quiz perfects
      lessons.forEach(l => {
        if (completedIds.has(l.id) && !lessonBadges.has(l.id)) {
          allBadges.push({ ...BADGE_DEFS.lesson_complete })
        }
      })

      badgeCount += allBadges.length
      diamondCount += allBadges.filter(b => b.tier === 'diamond').length
      goldCount += allBadges.filter(b => b.tier === 'gold').length

      return {
        discipline: disc,
        badges: allBadges,
        disciplineBadges: badges,
        lessonBadges,
        completedCount: completedIds.size,
        totalLessons: lessons.length,
      }
    })

    setDisciplineData(results.filter(r => r.badges.length > 0))
    setTotalBadges(badgeCount)
    setTotalDiamond(diamondCount)
    setTotalGold(goldCount)
    setLoading(false)
  }

  if (loading) {
    return <div className="loading-screen"><div className="spinner"></div></div>
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
      </div>

      {disciplineData.length === 0 ? (
        <div className="conquistas-empty">
          <div className="conquistas-empty-icon">🎮</div>
          <p>Você ainda não conquistou nenhum badge.</p>
          <p>Complete aulas e quizzes para ganhar conquistas!</p>
          <Link to="/disciplinas" className="btn-see-all" style={{ display: 'inline-block', marginTop: '1rem' }}>
            Ver Disciplinas →
          </Link>
        </div>
      ) : (
        disciplineData.map(({ discipline, disciplineBadges }) => (
          <DisciplineBadgeSection
            key={discipline.id}
            disciplineName={discipline.name}
            disciplineIcon={discipline.icon}
            badges={disciplineBadges}
          />
        ))
      )}
    </div>
  )
}
