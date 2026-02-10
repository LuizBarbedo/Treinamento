import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import { AuthProvider } from './contexts/AuthContext'
import ProtectedRoute from './components/ProtectedRoute'
import AdminRoute from './components/AdminRoute'
import Layout from './components/Layout'
import Login from './pages/Login'
import Dashboard from './pages/Dashboard'
import Disciplines from './pages/Disciplines'
import DisciplineDetail from './pages/DisciplineDetail'
import Quiz from './pages/Quiz'
import AdminDisciplines from './pages/admin/AdminDisciplines'
import AdminDisciplineEdit from './pages/admin/AdminDisciplineEdit'
import AdminReports from './pages/admin/AdminReports'

function App() {
  return (
    <BrowserRouter>
      <AuthProvider>
        <Routes>
          <Route path="/login" element={<Login />} />

          <Route
            element={
              <ProtectedRoute>
                <Layout />
              </ProtectedRoute>
            }
          >
            <Route path="/" element={<Dashboard />} />
            <Route path="/disciplinas" element={<Disciplines />} />
            <Route path="/disciplinas/:id" element={<DisciplineDetail />} />
            <Route path="/disciplinas/:id/quiz" element={<Quiz />} />

            {/* Admin Routes */}
            <Route path="/admin/disciplinas" element={
              <AdminRoute><AdminDisciplines /></AdminRoute>
            } />
            <Route path="/admin/disciplinas/:id" element={
              <AdminRoute><AdminDisciplineEdit /></AdminRoute>
            } />
            <Route path="/admin/relatorios" element={
              <AdminRoute><AdminReports /></AdminRoute>
            } />
          </Route>

          <Route path="*" element={<Navigate to="/" replace />} />
        </Routes>
      </AuthProvider>
    </BrowserRouter>
  )
}

export default App
