import { TIERS } from '../lib/badges'
import './Badges.css'

/**
 * Componente de badge individual
 */
export function Badge({ icon, name, description, tier, size = 'md', showLabel = true }) {
  const tierInfo = TIERS[tier] || TIERS.bronze

  return (
    <div className={`badge-item badge-${size} ${tierInfo.className}`} title={description}>
      <div className="badge-icon-wrapper">
        <span className="badge-icon">{icon}</span>
        {(tier === 'gold' || tier === 'diamond') && <div className="badge-shine" />}
        {tier === 'diamond' && <div className="badge-sparkles" />}
      </div>
      {showLabel && (
        <div className="badge-label">
          <span className="badge-name">{name}</span>
          <span className="badge-tier-tag">{tierInfo.label}</span>
        </div>
      )}
    </div>
  )
}

/**
 * Grid de badges para uma disciplina
 */
export function BadgeGrid({ badges, emptyMessage = 'Nenhuma conquista ainda.' }) {
  if (!badges || badges.length === 0) {
    return <div className="badge-grid-empty">{emptyMessage}</div>
  }

  return (
    <div className="badge-grid">
      {badges.map((badge, i) => (
        <Badge key={`${badge.id}-${i}`} {...badge} />
      ))}
    </div>
  )
}

/**
 * Seção de badges de uma disciplina (com cabeçalho)
 */
export function DisciplineBadgeSection({ disciplineName, disciplineIcon, badges, compact = false }) {
  return (
    <div className={`discipline-badge-section ${compact ? 'compact' : ''}`}>
      <div className="discipline-badge-header">
        <span className="discipline-badge-icon">{disciplineIcon || '📚'}</span>
        <span className="discipline-badge-title">{disciplineName}</span>
        <span className="discipline-badge-count">{badges.length} conquista{badges.length !== 1 ? 's' : ''}</span>
      </div>
      <BadgeGrid badges={badges} />
    </div>
  )
}

/**
 * Mini badges inline (para usar ao lado do nome de uma aula)
 */
export function InlineBadges({ badges }) {
  if (!badges || badges.length === 0) return null

  return (
    <span className="inline-badges">
      {badges.map((badge, i) => (
        <span
          key={`${badge.id}-${i}`}
          className={`inline-badge ${TIERS[badge.tier]?.className || ''}`}
          title={`${badge.name}: ${badge.description}`}
        >
          {badge.icon}
        </span>
      ))}
    </span>
  )
}

/**
 * Badge popup que aparece quando conquista nova é desbloqueada
 */
export function BadgeUnlocked({ badge, onClose }) {
  if (!badge) return null
  const tierInfo = TIERS[badge.tier] || TIERS.bronze

  return (
    <div className="badge-unlocked-overlay" onClick={onClose}>
      <div className="badge-unlocked-modal" onClick={e => e.stopPropagation()}>
        <div className="badge-unlocked-content">
          <div className="badge-unlocked-header">🎉 Nova Conquista!</div>
          <div className={`badge-unlocked-icon-wrapper ${tierInfo.className}`}>
            <span className="badge-unlocked-icon">{badge.icon}</span>
            {(badge.tier === 'gold' || badge.tier === 'diamond') && <div className="badge-shine badge-shine-large" />}
            {badge.tier === 'diamond' && <div className="badge-sparkles badge-sparkles-large" />}
          </div>
          <div className="badge-unlocked-name">{badge.name}</div>
          <div className="badge-unlocked-tier">{tierInfo.label}</div>
          <div className="badge-unlocked-desc">{badge.description}</div>
          <button className="badge-unlocked-btn" onClick={onClose}>Continuar</button>
        </div>
      </div>
    </div>
  )
}
