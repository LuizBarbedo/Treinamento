/**
 * Custom SVG icons with brand gradient (teal #009b8f → dark blue #00405b)
 * Matching the platform visual identity
 */

const GradientDef = ({ id }) => (
  <defs>
    <linearGradient id={id} x1="0%" y1="100%" x2="100%" y2="0%">
      <stop offset="0%" stopColor="#009b8f" />
      <stop offset="100%" stopColor="#00405b" />
    </linearGradient>
  </defs>
)

export function HomeIcon({ size = 24, className = '', gradient = false }) {
  const gradId = 'grad-home'
  const color = gradient ? `url(#${gradId})` : 'currentColor'
  return (
    <svg width={size} height={size} viewBox="0 0 64 64" fill="none" xmlns="http://www.w3.org/2000/svg" className={className}>
      {gradient && <GradientDef id={gradId} />}
      <path d="M32 6L4 28h8v24h14V38h12v14h14V28h8L32 6z" stroke={color} strokeWidth="5" strokeLinecap="round" strokeLinejoin="round" fill="none" />
      <path d="M26 52V38h12v14" stroke={color} strokeWidth="5" strokeLinecap="round" strokeLinejoin="round" fill="none" />
    </svg>
  )
}

export function GameControllerIcon({ size = 24, className = '', gradient = false }) {
  const gradId = 'grad-game'
  const color = gradient ? `url(#${gradId})` : 'currentColor'
  return (
    <svg width={size} height={size} viewBox="0 0 64 64" fill="none" xmlns="http://www.w3.org/2000/svg" className={className}>
      {gradient && <GradientDef id={gradId} />}
      <path d="M8 24C8 18 13 14 20 14h24c7 0 12 4 12 10v12c0 8-4 16-10 16-4 0-6-2-8-6l-2-4h-8l-2 4c-2 4-4 6-8 6-6 0-10-8-10-16V24z" stroke={color} strokeWidth="5" strokeLinecap="round" strokeLinejoin="round" fill="none" />
      <circle cx="42" cy="24" r="2" fill={color} />
      <circle cx="48" cy="28" r="2" fill={color} />
      <circle cx="42" cy="32" r="2" fill={color} />
      <circle cx="36" cy="28" r="2" fill={color} />
      <path d="M20 24v8M16 28h8" stroke={color} strokeWidth="4" strokeLinecap="round" />
    </svg>
  )
}

export function BookOpenIcon({ size = 24, className = '', gradient = false }) {
  const gradId = 'grad-book-open'
  const color = gradient ? `url(#${gradId})` : 'currentColor'
  return (
    <svg width={size} height={size} viewBox="0 0 64 64" fill="none" xmlns="http://www.w3.org/2000/svg" className={className}>
      {gradient && <GradientDef id={gradId} />}
      <path d="M32 52c-4-3-10-5-18-5-4 0-7 .5-10 1V14c3-.5 6-1 10-1 8 0 14 2 18 5m0 34c4-3 10-5 18-5 4 0 7 .5 10 1V14c-3-.5-6-1-10-1-8 0-14 2-18 5m0 34V18" stroke={color} strokeWidth="5" strokeLinecap="round" strokeLinejoin="round" fill="none" />
    </svg>
  )
}

export function BooksStackIcon({ size = 24, className = '', gradient = false }) {
  const gradId = 'grad-books'
  const color = gradient ? `url(#${gradId})` : 'currentColor'
  return (
    <svg width={size} height={size} viewBox="0 0 64 64" fill="none" xmlns="http://www.w3.org/2000/svg" className={className}>
      {gradient && <GradientDef id={gradId} />}
      <rect x="8" y="36" width="40" height="10" rx="2" stroke={color} strokeWidth="4.5" fill="none" />
      <rect x="10" y="24" width="40" height="10" rx="2" stroke={color} strokeWidth="4.5" fill="none" />
      <rect x="8" y="12" width="40" height="10" rx="2" stroke={color} strokeWidth="4.5" fill="none" />
      <path d="M50 44v6c0 1-1 2-2 2H12" stroke={color} strokeWidth="4.5" strokeLinecap="round" fill="none" />
    </svg>
  )
}

export function MedalIcon({ size = 24, className = '', gradient = false }) {
  const gradId = 'grad-medal'
  const color = gradient ? `url(#${gradId})` : 'currentColor'
  return (
    <svg width={size} height={size} viewBox="0 0 64 64" fill="none" xmlns="http://www.w3.org/2000/svg" className={className}>
      {gradient && <GradientDef id={gradId} />}
      <path d="M32 6l4 8 8 1-6 6 2 8-8-4-8 4 2-8-6-6 8-1z" stroke={color} strokeWidth="4" strokeLinejoin="round" fill="none" />
      <circle cx="32" cy="34" r="16" stroke={color} strokeWidth="5" fill="none" />
      <circle cx="32" cy="34" r="8" stroke={color} strokeWidth="3" fill="none" />
      <path d="M24 50l-4 10 12-4 12 4-4-10" stroke={color} strokeWidth="4" strokeLinecap="round" strokeLinejoin="round" fill="none" />
    </svg>
  )
}

export function TrendingUpIcon({ size = 24, className = '', gradient = false }) {
  const gradId = 'grad-trending'
  const color = gradient ? `url(#${gradId})` : 'currentColor'
  return (
    <svg width={size} height={size} viewBox="0 0 64 64" fill="none" xmlns="http://www.w3.org/2000/svg" className={className}>
      {gradient && <GradientDef id={gradId} />}
      <path d="M6 50L22 34l10 10L56 14" stroke={color} strokeWidth="6" strokeLinecap="round" strokeLinejoin="round" fill="none" />
      <path d="M42 14h14v14" stroke={color} strokeWidth="6" strokeLinecap="round" strokeLinejoin="round" fill="none" />
    </svg>
  )
}

export function BarChartIcon({ size = 24, className = '', gradient = false }) {
  const gradId = 'grad-barchart'
  const color = gradient ? `url(#${gradId})` : 'currentColor'
  return (
    <svg width={size} height={size} viewBox="0 0 64 64" fill="none" xmlns="http://www.w3.org/2000/svg" className={className}>
      {gradient && <GradientDef id={gradId} />}
      <rect x="6" y="34" width="10" height="22" rx="2" stroke={color} strokeWidth="4.5" fill="none" />
      <rect x="20" y="16" width="10" height="40" rx="2" stroke={color} strokeWidth="4.5" fill="none" />
      <rect x="34" y="8" width="10" height="48" rx="2" stroke={color} strokeWidth="4.5" fill="none" />
      <rect x="48" y="26" width="10" height="30" rx="2" stroke={color} strokeWidth="4.5" fill="none" />
      <line x1="4" y1="58" x2="60" y2="58" stroke={color} strokeWidth="4" strokeLinecap="round" />
    </svg>
  )
}

export function TrophyIcon({ size = 24, className = '', gradient = false }) {
  const gradId = 'grad-trophy'
  const color = gradient ? `url(#${gradId})` : 'currentColor'
  return (
    <svg width={size} height={size} viewBox="0 0 64 64" fill="none" xmlns="http://www.w3.org/2000/svg" className={className}>
      {gradient && <GradientDef id={gradId} />}
      <path d="M18 8h28v18c0 10-6 18-14 18S18 36 18 26V8z" stroke={color} strokeWidth="5" strokeLinejoin="round" fill="none" />
      <path d="M18 14H10c-2 0-4 2-4 4v4c0 6 4 10 10 10h2" stroke={color} strokeWidth="4.5" strokeLinecap="round" fill="none" />
      <path d="M46 14h8c2 0 4 2 4 4v4c0 6-4 10-10 10h-2" stroke={color} strokeWidth="4.5" strokeLinecap="round" fill="none" />
      <path d="M32 44v6" stroke={color} strokeWidth="5" strokeLinecap="round" />
      <path d="M22 54h20c2 0 3 1 3 3H19c0-2 1-3 3-3z" stroke={color} strokeWidth="4" strokeLinejoin="round" fill="none" />
      <path d="M32 16l2 4 4 .5-3 3 1 4-4-2-4 2 1-4-3-3 4-.5z" fill={color} />
    </svg>
  )
}

export function GraduationCapIcon({ size = 24, className = '', gradient = false }) {
  const gradId = 'grad-graduation'
  const color = gradient ? `url(#${gradId})` : 'currentColor'
  return (
    <svg width={size} height={size} viewBox="0 0 64 64" fill="none" xmlns="http://www.w3.org/2000/svg" className={className}>
      {gradient && <GradientDef id={gradId} />}
      <path d="M32 8L2 24l30 16 30-16L32 8z" stroke={color} strokeWidth="4.5" strokeLinejoin="round" fill="none" />
      <path d="M14 31v14c0 4 8 9 18 9s18-5 18-9V31" stroke={color} strokeWidth="4.5" strokeLinecap="round" strokeLinejoin="round" fill="none" />
      <path d="M56 24v20" stroke={color} strokeWidth="4.5" strokeLinecap="round" />
      <circle cx="56" cy="46" r="2.5" fill={color} />
    </svg>
  )
}

export function BalanceIcon({ size = 24, className = '', gradient = false }) {
  const gradId = 'grad-balance'
  const color = gradient ? `url(#${gradId})` : 'currentColor'
  return (
    <svg width={size} height={size} viewBox="0 0 64 64" fill="none" xmlns="http://www.w3.org/2000/svg" className={className}>
      {gradient && <GradientDef id={gradId} />}
      <line x1="32" y1="6" x2="32" y2="52" stroke={color} strokeWidth="4.5" strokeLinecap="round" />
      <circle cx="32" cy="8" r="4" stroke={color} strokeWidth="3.5" fill="none" />
      <line x1="12" y1="16" x2="52" y2="16" stroke={color} strokeWidth="4.5" strokeLinecap="round" />
      <path d="M4 38l8-22 8 22c0 4-3.5 6-8 6s-8-2-8-6z" stroke={color} strokeWidth="3.5" strokeLinejoin="round" fill="none" />
      <path d="M44 38l8-22 8 22c0 4-3.5 6-8 6s-8-2-8-6z" stroke={color} strokeWidth="3.5" strokeLinejoin="round" fill="none" />
      <path d="M24 52h16" stroke={color} strokeWidth="5" strokeLinecap="round" />
    </svg>
  )
}
