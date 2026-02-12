import { createContext, useContext, useEffect, useState } from 'react'
import { supabase } from '../lib/supabase'

const ADMIN_EMAIL = 'aplicacao.treinamento@gmail.com'

const AuthContext = createContext({})

export const useAuth = () => useContext(AuthContext)

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null)
  const [loading, setLoading] = useState(true)
  const [isAdmin, setIsAdmin] = useState(false)
  const [isMonitor, setIsMonitor] = useState(false)
  const [userRole, setUserRole] = useState('user') // 'admin' | 'monitor' | 'user'

  const checkRoles = async (currentUser) => {
    if (!currentUser) {
      setIsAdmin(false)
      setIsMonitor(false)
      setUserRole('user')
      return
    }
    // Verifica pelo email do master admin
    if (currentUser.email === ADMIN_EMAIL) {
      setIsAdmin(true)
      setIsMonitor(false)
      setUserRole('admin')
      return
    }
    // Verifica na tabela user_roles
    try {
      const { data } = await supabase
        .from('user_roles')
        .select('role')
        .eq('user_id', currentUser.id)
        .single()
      const role = data?.role || 'user'
      setIsAdmin(role === 'admin')
      setIsMonitor(role === 'monitor')
      setUserRole(role)
    } catch {
      setIsAdmin(false)
      setIsMonitor(false)
      setUserRole('user')
    }
  }

  useEffect(() => {
    supabase.auth.getSession()
      .then(({ data: { session } }) => {
        const currentUser = session?.user ?? null
        setUser(currentUser)
        return checkRoles(currentUser)
      })
      .catch((err) => {
        console.warn('Erro ao obter sessão:', err.message)
      })
      .finally(() => {
        setLoading(false)
      })

    let subscription
    try {
      const { data } = supabase.auth.onAuthStateChange(
        (_event, session) => {
          const currentUser = session?.user ?? null
          setUser(currentUser)
          checkRoles(currentUser)
        }
      )
      subscription = data?.subscription
    } catch (err) {
      console.warn('Erro ao configurar auth listener:', err.message)
    }

    return () => subscription?.unsubscribe()
  }, [])

  const signIn = async (email, password) => {
    const { error } = await supabase.auth.signInWithPassword({ email, password })
    return { error }
  }

  const signUp = async (email, password, fullName, monitorCode = null) => {
    const { data, error } = await supabase.auth.signUp({
      email,
      password,
      options: { data: { full_name: fullName } }
    })

    // Se cadastro OK e tem código de monitor, tentar atribuir role
    if (!error && data?.user && monitorCode) {
      try {
        const { data: result } = await supabase.rpc('claim_monitor_role', {
          p_access_code: monitorCode
        })
        if (result && !result.success) {
          return { error: null, monitorError: result.message }
        }
      } catch (err) {
        console.warn('Aviso: não foi possível atribuir role de monitor:', err.message)
        return { error: null, monitorError: 'Não foi possível atribuir o papel de monitor. Entre em contato com o administrador.' }
      }
    }

    return { error }
  }

  const resetPassword = async (email) => {
    const { error } = await supabase.auth.resetPasswordForEmail(email, {
      redirectTo: `${window.location.origin}/redefinir-senha`
    })
    return { error }
  }

  const updatePassword = async (newPassword) => {
    const { error } = await supabase.auth.updateUser({ password: newPassword })
    return { error }
  }

  const signOut = async () => {
    await supabase.auth.signOut()
    setIsAdmin(false)
    setIsMonitor(false)
    setUserRole('user')
  }

  return (
    <AuthContext.Provider value={{ user, loading, isAdmin, isMonitor, userRole, signIn, signUp, signOut, resetPassword, updatePassword }}>
      {children}
    </AuthContext.Provider>
  )
}
