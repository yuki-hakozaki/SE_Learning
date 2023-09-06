module.exports = {
    deploy: {
      production: {
        user: 'ec2-user',
        host: 'ec2-54-64-138-161.ap-northeast-1.compute.amazonaws.com',
        key: `/home/hakozaki-ubuntu/SE_leraning/課題3/SSH_key/2nd_key.pem`,
        ref: `origin/fix1`,
        repo: 'git@github.com:yuki-hakozaki/Ansible_deploy.git',
        path: '/home/ec2-user/app/',
        "post-deploy":
        'cd /home/ec2-user/app/source/React/back && yarn install && npx tsc --esModuleInterop server.ts && cd ../front && yarn install && npm run build && cd .. && pm2 start ecosystem.config.js',
        env: {
          NODE_ENV: 'production'
        }
      }
    }
  };
