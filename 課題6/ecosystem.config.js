module.exports = {
    apps: [
    {
      name: 'front',
      script: './frontstart.js',
      instances: 'max',
      autorestart: true,
      watch: false,
      max_memory_restart: '1G'
    },
    {
      name: 'back',
      script: './server.js',
      instances: 'max',
      autorestart: true,
      watch: false,
      max_memory_restart: '1G'
    }
],
    deploy: {
      production: {
        user: 'ec2-user',
        host: 'ec2-54-64-138-161.ap-northeast-1.compute.amazonaws.com',
        key: `/home/hakozaki-ubuntu/SE_leraning/課題3/SSH_key/2nd_key.pem`,
        ref: `origin/main`,
        repo: 'git@github.com:yuki-hakozaki/Ansible_deploy.git',
        path: '/home/ec2-user/app/',
        "post-deploy":
        'cd /home/ec2-user/app/current/deploy_app/back && yarn install && npx tsc --help && npx tsc --esModuleInterop server.ts && pm2 start server.js && cd ../front_pak && yarn install && pm2 start frontstart.js',
        env: {
          NODE_ENV: 'production'
        }
      }
    }
  };
