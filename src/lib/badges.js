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
  lesson_quiz_done: {
    id: 'lesson_quiz_done',
    name: 'Quiz Respondido',
    description: 'Respondeu o quiz da aula',
    icon: '📝',
    tier: 'bronze',
  },
  lesson_quiz_perfect: {
    id: 'lesson_quiz_perfect',
    name: 'Nota Máxima',
    description: 'Acertou 100% no quiz da aula',
    icon: '⭐',
    tier: 'gold',
  },

  // ---- Por disciplina ----
  all_lessons_complete: {
    id: 'all_lessons_complete',
    name: 'Todas as Aulas',
    description: 'Completou todas as aulas da disciplina',
    icon: '🏆',
    tier: 'silver',
  },
  final_quiz_complete: {
    id: 'final_quiz_complete',
    name: 'Quiz Aprovado',
    description: 'Aprovado no quiz geral da disciplina',
    icon: '🎯',
    tier: 'silver',
  },
  discipline_complete: {
    id: 'discipline_complete',
    name: 'Disciplina Completa',
    description: 'Completou todas as aulas e o quiz geral da disciplina',
    icon: '🎖️',
    tier: 'gold',
  },

  // ---- Global ----
  all_disciplines_complete: {
    id: 'all_disciplines_complete',
    name: 'Formatura',
    description: 'Completou todas as disciplinas da plataforma',
    icon: '👑',
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

    // Quiz respondido
    const quizResult = lessonQuizResults.find(r => r.lesson_id === lesson.id)
    if (quizResult) {
      lb.push({ ...BADGE_DEFS.lesson_quiz_done })

      // Quiz perfeito da aula
      if (quizResult.score === 100) {
        lb.push({ ...BADGE_DEFS.lesson_quiz_perfect })
        perfectLessonIds.add(lesson.id)
      }
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

  // --- Badge: Quiz geral aprovado ---
  const finalQuizPassed = finalQuizResult && finalQuizResult.score >= 70
  if (finalQuizPassed) {
    badges.push({ ...BADGE_DEFS.final_quiz_complete })
  }

  // --- Badge: Disciplina completa (todas as aulas + quiz geral) ---
  if (allLessonsComplete && finalQuizPassed) {
    badges.push({ ...BADGE_DEFS.discipline_complete })
  }

  return { badges, perfectLessonIds, lessonBadges }
}

/**
 * Conta o total de badges de uma disciplina (discipline-level + lesson-level).
 */
export function countDisciplineBadges({ badges, lessonBadges }) {
  let count = badges.length
  lessonBadges.forEach(lb => { count += lb.length })
  return count
}

/**
 * Junta todos os badges de uma disciplina em uma lista única.
 */
export function getAllDisciplineBadges({ badges, lessonBadges }) {
  const all = [...badges]
  lessonBadges.forEach(lb => { all.push(...lb) })
  return all
}
