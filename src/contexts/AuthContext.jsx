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
  const [accessLevel, setAccessLevel] = useState('basico') // 'basico' | 'intermediario' | 'avancado'
  const [mustResetPassword, setMustResetPassword] = useState(false)

  const configuredResetRedirect = import.meta.env.VITE_PASSWORD_RESET_REDIRECT_URL?.trim()
  const passwordResetRedirectTo = configuredResetRedirect || `${window.location.origin}/redefinir-senha`

  const shouldResetPassword = (currentUser) =>
    Boolean(currentUser?.user_metadata?.must_reset_password)

  const checkRoles = async (currentUser) => {
    if (!currentUser) {
      setIsAdmin(false)
      setIsMonitor(false)
      setUserRole('user')
      setAccessLevel('basico')
      setMustResetPassword(false)
      return
    }

    setMustResetPassword(shouldResetPassword(currentUser))

    // Verifica pelo email do master admin
    if (currentUser.email === ADMIN_EMAIL) {
      setIsAdmin(true)
      setIsMonitor(false)
      setUserRole('admin')
      setAccessLevel('avancado')
      return
    }
    // Verifica na tabela user_roles
    try {
      const { data } = await supabase
        .from('user_roles')
        .select('role, access_level')
        .eq('user_id', currentUser.id)
        .single()
      const role = data?.role || 'user'
      setIsAdmin(role === 'admin')
      setIsMonitor(role === 'monitor')
      setUserRole(role)
      setAccessLevel(data?.access_level || 'basico')
    } catch {
      setIsAdmin(false)
      setIsMonitor(false)
      setUserRole('user')
      setAccessLevel('basico')
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
    const { data, error } = await supabase.auth.signInWithPassword({ email, password })
    return {
      error,
      mustResetPassword: shouldResetPassword(data?.user)
    }
  }

  const signUp = async (email, password, fullName, monitorCode = null) => {
    const { data, error } = await supabase.auth.signUp({
      email,
      password,
      options: {
        data: {
          full_name: fullName,
          must_reset_password: true
        }
      }
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
      redirectTo: passwordResetRedirectTo
    })
    return { error }
  }

  const updatePassword = async (newPassword) => {
    const currentMetadata = user?.user_metadata || {}
    const { error } = await supabase.auth.updateUser({
      password: newPassword,
      data: {
        ...currentMetadata,
        must_reset_password: false
      }
    })

    if (!error) {
      setMustResetPassword(false)
    }

    return { error }
  }

  const signOut = async () => {
    await supabase.auth.signOut()
    setIsAdmin(false)
    setIsMonitor(false)
    setUserRole('user')
    setAccessLevel('basico')
    setMustResetPassword(false)
  }

  return (
    <AuthContext.Provider value={{ user, loading, isAdmin, isMonitor, userRole, accessLevel, mustResetPassword, signIn, signUp, signOut, resetPassword, updatePassword }}>
      {children}
    </AuthContext.Provider>
  )
}
