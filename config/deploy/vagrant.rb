set :repo_url,  'https://github.com/galanin/whoosh-directory.git'
set :deploy_to, '/home/staff/app'
set :branch,    'nodes'
set :rack_env,  'production'
set :puma_env,  'production'

server 'staff.vagrant', user: 'staff', roles: %w{api web}, ssh_options: { forward_agent: true }

append :linked_dirs, 'node_modules'

set :yarn_flags, '--silent --no-progress'
set :yarn_roles, :web

set :bundle_jobs, 1
