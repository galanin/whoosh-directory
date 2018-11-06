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
      API_BASE_URL: 'http://staff:8002/api',
      APPLICATION_BASE_URL: 'http://staff',
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
