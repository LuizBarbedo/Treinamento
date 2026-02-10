// ============================================
// Sistema de Gamificação - Definições e Lógica de Badges
// ============================================

// Tiers visuais dos badges
export const TIERS = {
  bronze: { label: 'Bronze', className: 'badge-bronze' },
  silver: { label: 'Prata', className: 'badge-silver' },
  gold: { label: 'Ouro', className: 'badge-gold' },
  diamond: { label: 'Diamante', className: 'badge-diamond' },
}

// Definições de todos os badges possíveis
export const BADGE_DEFS = {
  // ---- Por aula ----
  lesson_complete: {
    id: 'lesson_complete',
    name: 'Aula Concluída',
    description: 'Completou uma aula com sucesso',
    icon: '📗',
    tier: 'bronze',
  },
  lesson_quiz_perfect: {
    id: 'lesson_quiz_perfect',
    name: 'Nota Máxima',
    description: 'Acertou 100% no quiz da aula',
    icon: '⭐',
    tier: 'gold',
  },

  // ---- Por disciplina (aulas) ----
  all_lessons_complete: {
    id: 'all_lessons_complete',
    name: 'Todas as Aulas',
    description: 'Completou todas as aulas da disciplina',
    icon: '🏆',
    tier: 'gold',
  },

  // ---- Por disciplina (quizzes de aula) ----
  all_quizzes_perfect: {
    id: 'all_quizzes_perfect',
    name: 'Mestre dos Quizzes',
    description: 'Acertou 100% em todos os quizzes de aula',
    icon: '💎',
    tier: 'diamond',
  },
  all_quizzes_great: {
    id: 'all_quizzes_great',
    name: 'Quase Perfeito',
    description: 'Média acima de 80% nos quizzes de aula',
    icon: '🌟',
    tier: 'silver',
  },
  all_quizzes_good: {
    id: 'all_quizzes_good',
    name: 'Bom Desempenho',
    description: 'Média acima de 60% nos quizzes de aula',
    icon: '✨',
    tier: 'bronze',
  },

  // ---- Quiz final da disciplina ----
  final_quiz_passed: {
    id: 'final_quiz_passed',
    name: 'Aprovado',
    description: 'Aprovado no quiz final da disciplina',
    icon: '🎯',
    tier: 'silver',
  },
  final_quiz_perfect: {
    id: 'final_quiz_perfect',
    name: 'Gabaritou',
    description: 'Nota máxima no quiz final da disciplina',
    icon: '👑',
    tier: 'diamond',
  },

  // ---- Maestria total ----
  discipline_master: {
    id: 'discipline_master',
    name: 'Especialista',
    description: 'Completou tudo com nota máxima na disciplina',
    icon: '🎖️',
    tier: 'diamond',
  },
}

/**
 * Computa os badges de uma disciplina específica.
 *
 * @param {Object} params
 * @param {Array} params.lessons - Lista de aulas da disciplina
 * @param {Set} params.completedLessonIds - IDs das aulas concluídas
 * @param {Array} params.lessonQuizResults - Resultados dos quizzes de aula [{ lesson_id, score, correct_answers, total_questions }]
 * @param {Object|null} params.finalQuizResult - Resultado do quiz final { score }
 * @returns {{ badges: Array, perfectLessonIds: Set, lessonBadges: Map }}
 */
export function computeDisciplineBadges({ lessons, completedLessonIds, lessonQuizResults, finalQuizResult }) {
  const badges = []
  const perfectLessonIds = new Set()
  const lessonBadges = new Map() // lessonId -> array of badges

  // --- Badges por aula ---
  lessons.forEach(lesson => {
    const lb = []

    // Aula concluída
    if (completedLessonIds.has(lesson.id)) {
      lb.push({ ...BADGE_DEFS.lesson_complete })
    }

    // Quiz perfeito da aula
    const quizResult = lessonQuizResults.find(r => r.lesson_id === lesson.id)
    if (quizResult && quizResult.score === 100) {
      lb.push({ ...BADGE_DEFS.lesson_quiz_perfect })
      perfectLessonIds.add(lesson.id)
    }

    if (lb.length > 0) {
      lessonBadges.set(lesson.id, lb)
    }
  })

  // --- Badge: Todas as aulas concluídas ---
  const allLessonsComplete = lessons.length > 0 && completedLessonIds.size >= lessons.length
  if (allLessonsComplete) {
    badges.push({ ...BADGE_DEFS.all_lessons_complete })
  }

  // --- Badges de performance dos quizzes de aula ---
  // Só computa se o aluno fez pelo menos 1 quiz de aula
  if (lessonQuizResults.length > 0) {
    const avgScore = lessonQuizResults.reduce((sum, r) => sum + r.score, 0) / lessonQuizResults.length
    const allPerfect = lessonQuizResults.every(r => r.score === 100)
    const didAllQuizzes = lessonQuizResults.length >= lessons.length

    if (allPerfect && didAllQuizzes) {
      badges.push({ ...BADGE_DEFS.all_quizzes_perfect })
    } else if (avgScore >= 80) {
      badges.push({ ...BADGE_DEFS.all_quizzes_great })
    } else if (avgScore >= 60) {
      badges.push({ ...BADGE_DEFS.all_quizzes_good })
    }
  }

  // --- Badge: Quiz final ---
  if (finalQuizResult) {
    if (finalQuizResult.score === 100) {
      badges.push({ ...BADGE_DEFS.final_quiz_perfect })
    } else if (finalQuizResult.score >= 70) {
      badges.push({ ...BADGE_DEFS.final_quiz_passed })
    }
  }

  // --- Badge: Maestria total ---
  const allQuizzesPerfect = lessonQuizResults.length >= lessons.length && lessonQuizResults.every(r => r.score === 100)
  const finalPerfect = finalQuizResult?.score === 100
  if (allLessonsComplete && allQuizzesPerfect && finalPerfect) {
    badges.push({ ...BADGE_DEFS.discipline_master })
  }

  return { badges, perfectLessonIds, lessonBadges }
}

/**
 * Computa badges globais (cross-disciplina).
 *
 * @param {Array} disciplineResults - Array de { disciplineId, disciplineName, disciplineIcon, badges, totalLessons, completedLessons }
 * @returns {{ totalBadges: number, disciplineResults: Array }}
 */
export function computeGlobalStats(disciplineResults) {
  let totalBadges = 0

  disciplineResults.forEach(dr => {
    // Conta badges de disciplina
    totalBadges += dr.badges.length
    // Conta badges por aula (lesson_complete + lesson_quiz_perfect)
    totalBadges += dr.perfectLessonCount
    totalBadges += dr.completedLessons
  })

  return { totalBadges, disciplineResults }
}
