module.exports = {
  apps : [{
    name      : 'staff_production',
    cwd       : '/home/deployer/staff_production/current',
    script    : '/home/deployer/staff_production/current/dist/index.js',
    env: {
      NODE_ENV: 'development'
    },
    env_production : {
      NODE_ENV: 'production',
      APPLICATION_PORT: 8001,
      CLIENT_SIDE_API_BASE_URL: '/api',
      SERVER_SIDE_API_BASE_URL: 'http://localhost:8002/api',
      PUBLIC_ASSET_PATH: '/'
    }
  }],

  deploy : {
    production : {
      user : 'deployer',
      host : 'staff',
      ref  : 'origin/master',
      repo : 'git@github.com:galanin/whoosh-directory.git',
      path : '/home/deployer/staff_production/current',
      'post-deploy' : 'yarn install --production --silent --no-progress && npm run prod:build && pm2 reload /home/deployer/staff_production/shared/ecosystem.config.js --env production'
    }
  }
};
