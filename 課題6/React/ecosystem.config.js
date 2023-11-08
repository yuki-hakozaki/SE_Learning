module.exports = {
  apps: [
  {
    name: 'front',
    script: './front/frontstart.js',
    instances: 'max',
    autorestart: true,
    watch: false,
    max_memory_restart: '1G'
  },
  {
    name: 'back',
    script: './back/server.js',
    instances: 'max',
    autorestart: true,
    watch: false,
    max_memory_restart: '1G'
  }
]}