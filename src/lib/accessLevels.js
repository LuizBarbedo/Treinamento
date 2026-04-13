export const ACCESS_LEVELS = ['basico', 'intermediario', 'avancado']

export const ACCESS_LEVEL_LABELS = {
  basico: 'Básico',
  intermediario: 'Intermediário',
  avancado: 'Avançado',
}

const RANK = { basico: 0, intermediario: 1, avancado: 2 }

export function hasAccessLevel(userLevel, requiredLevel) {
  const u = RANK[userLevel] ?? 0
  const r = RANK[requiredLevel] ?? 0
  return u >= r
}

export const canSeeReflexao = (level) => hasAccessLevel(level, 'intermediario')
export const canSeeArtigoTecnico = (level) => hasAccessLevel(level, 'avancado')
