set :repo_url, 'https://github.com/galanin/whoosh-directory.git'
set :deploy_to, '/home/deployer/staff_staging'
set :branch, :master
set :rack_env, 'production'
set :puma_env, 'production'

server 'staff', user: 'deployer', roles: %w{api web}, ssh_options: { forward_agent: true }
