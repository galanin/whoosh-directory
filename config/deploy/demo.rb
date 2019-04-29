set :repo_url, 'https://github.com/galanin/whoosh-directory.git'
set :deploy_to, '/home/deployer/staff_production'
set :branch, :nodes
set :rack_env, 'production'
set :puma_env, 'production'

server 'staff-demo', user: 'deployer', roles: %w{api web}, ssh_options: { forward_agent: true }

append :linked_dirs, 'node_modules'

set :yarn_flags, '--silent --no-progress'
set :yarn_roles, :web
