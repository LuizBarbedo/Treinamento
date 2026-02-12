import { Navigate } from 'react-router-dom'
import { useAuth } from '../contexts/AuthContext'

export default function MonitorRoute({ children }) {
  const { user, loading, isMonitor } = useAuth()

  if (loading) {
    return (
      <div className="loading-screen">
        <div className="spinner"></div>
        <p>Carregando...</p>
      </div>
    )
  }

  if (!user) {
    return <Navigate to="/login" replace />
  }

  if (!isMonitor) {
    return <Navigate to="/" replace />
  }

  return children
}
