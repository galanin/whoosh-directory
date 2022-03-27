set :repo_url,  'https://github.com/galanin/whoosh-directory.git'
set :deploy_to, '/home/staff/app'
set :branch,    'master'
set :rack_env,  'production'
set :puma_env,  'production'

server 'staff-demo2', user: 'staff', roles: %w{api web}, ssh_options: { forward_agent: true }

append :linked_dirs, 'node_modules', 'node_modules_cache'

set :yarn_flags, '--silent --no-progress'
set :yarn_roles, :web

set :bundle_jobs, 1
