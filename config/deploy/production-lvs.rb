set :repo_url, 'http://gitlab/web/staff.git'
set :deploy_to, '/home/deployer/staff_production'
set :branch, :master
set :puma_env, 'production'

server 'staff', user: 'deployer', roles: %w{api web}, ssh_options: { forward_agent: true }
