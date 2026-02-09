import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL || ''
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY || ''

if (!supabaseUrl || !supabaseAnonKey || supabaseUrl.includes('SUA_SUPABASE')) {
  console.warn(
    '⚠️ Supabase não configurado! Edite o arquivo .env com suas credenciais.\n' +
    'Veja o README ou supabase/schema.sql para instruções.'
  )
}

export const supabase = createClient(
  supabaseUrl.startsWith('http') ? supabaseUrl : 'https://placeholder.supabase.co',
  supabaseAnonKey || 'placeholder'
)
