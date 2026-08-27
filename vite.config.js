import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  server: {
    host: '0.0.0.0',
    port: 8571,
    strictPort: true,
    proxy: {
      '/ollama-api': {
        target: 'https://ollama.com',
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/ollama-api/, '')
      }
    }
  },
  preview: {
    host: '0.0.0.0',
    port: 8571,
    strictPort: true,
  },
})
