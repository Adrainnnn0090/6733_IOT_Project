import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    host: '0.0.0.0', // 开放给局域网访问
    port: 5173,
    allowedHosts: ['adddd.local'], // 👈 添加这行
  },
})