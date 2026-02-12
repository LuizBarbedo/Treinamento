import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import { AuthProvider } from './contexts/AuthContext'
import ProtectedRoute from './components/ProtectedRoute'
import AdminRoute from './components/AdminRoute'
import MonitorRoute from './components/MonitorRoute'
import Layout from './components/Layout'
import Login from './pages/Login'
import Dashboard from './pages/Dashboard'
import Disciplines from './pages/Disciplines'
import DisciplineDetail from './pages/DisciplineDetail'
import Quiz from './pages/Quiz'
import Conquistas from './pages/Conquistas'
import MyDoubts from './pages/MyDoubts'
import StudentDoubtDetail from './pages/StudentDoubtDetail'
import AdminDisciplines from './pages/admin/AdminDisciplines'
import AdminDisciplineEdit from './pages/admin/AdminDisciplineEdit'
import AdminReports from './pages/admin/AdminReports'
import AdminMonitors from './pages/admin/AdminMonitors'
import MonitorDashboard from './pages/monitor/MonitorDashboard'
import MonitorStudents from './pages/monitor/MonitorStudents'
import MonitorStudentDetail from './pages/monitor/MonitorStudentDetail'
import MonitorDoubts from './pages/monitor/MonitorDoubts'
import MonitorDoubtDetail from './pages/monitor/MonitorDoubtDetail'
import ForgotPassword from './pages/ForgotPassword'
import ResetPassword from './pages/ResetPassword'
import Forum from './pages/Forum'
import ForumPost from './pages/ForumPost'

function App() {
  return (
    <BrowserRouter>
      <AuthProvider>
        <Routes>
          <Route path="/login" element={<Login />} />
          <Route path="/esqueci-senha" element={<ForgotPassword />} />
          <Route path="/redefinir-senha" element={<ResetPassword />} />

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
            <Route path="/conquistas" element={<Conquistas />} />
            <Route path="/forum" element={<Forum />} />
            <Route path="/forum/:postId" element={<ForumPost />} />

            {/* Student Doubts Routes */}
            <Route path="/minhas-duvidas" element={<MyDoubts />} />
            <Route path="/minhas-duvidas/:doubtId" element={<StudentDoubtDetail />} />

            {/* Monitor Routes */}
            <Route path="/monitor" element={
              <MonitorRoute><MonitorDashboard /></MonitorRoute>
            } />
            <Route path="/monitor/alunos" element={
              <MonitorRoute><MonitorStudents /></MonitorRoute>
            } />
            <Route path="/monitor/alunos/:studentId" element={
              <MonitorRoute><MonitorStudentDetail /></MonitorRoute>
            } />
            <Route path="/monitor/duvidas" element={
              <MonitorRoute><MonitorDoubts /></MonitorRoute>
            } />
            <Route path="/monitor/duvidas/:doubtId" element={
              <MonitorRoute><MonitorDoubtDetail /></MonitorRoute>
            } />

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
            <Route path="/admin/monitores" element={
              <AdminRoute><AdminMonitors /></AdminRoute>
            } />
          </Route>

          <Route path="*" element={<Navigate to="/" replace />} />
        </Routes>
      </AuthProvider>
    </BrowserRouter>
  )
}

export default App
