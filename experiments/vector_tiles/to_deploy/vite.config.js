import { defineConfig } from 'vite'

export default defineConfig({
  base: './',
  build: {
    outDir: 'dist',
    assetsDir: 'assets',
    sourcemap: true,
    rollupOptions: {
      output: {
        manualChunks: {
          'maplibre': ['maplibre-gl'],
          'statistics': ['simple-statistics']
        }
      }
    }
  },
  server: {
    port: 3000,
    host: "0.0.0.0",
    open: true
  }
})