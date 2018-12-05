set :repo_url, 'git@gitlab:web/staff.git'
set :deploy_to, '/home/deployer/staff_staging'
set :branch, :master
set :rack_env, 'production'
set :puma_env, 'production'

server 'staff', user: 'deployer', roles: %w{api web}, ssh_options: { forward_agent: true }

set :yarn_flags, '--offline --silent --no-progress'
set :yarn_roles, :web

append :linked_dirs, 'vendor/cache'

set :bundle_flags, '--deployment --local'

after 'yarn:install', 'staff:fix_node_sass'

set :whenever_roles, :api
set :whenever_environment, 'production'
set :whenever_identifier, 'staff_staging'
set :whenever_command_environment_variables, -> { fetch(:default_env).merge(rack_env: fetch(:whenever_environment)) }
set :whenever_path, -> { release_path }
set :whenever_load_file, -> { "#{release_path}/config/schedule_import.rb" }
append :linked_files, 'config/schedule_import.rb'
