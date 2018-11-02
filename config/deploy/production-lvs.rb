set :repo_url, 'git@gitlab:web/staff.git'
set :deploy_to, '/home/deployer/staff_production'
set :branch, :master
set :rack_env, 'production'
set :puma_env, 'production'

server 'staff', user: 'deployer', roles: %w{api web}, ssh_options: { forward_agent: true }

set :yarn_flags, '--offline --silent --no-progress'
set :yarn_roles, :web

append :linked_dirs, 'vendor/cache'

set :bundle_flags, '--deployment --local'
