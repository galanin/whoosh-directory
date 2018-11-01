# config valid for current version and patch releases of Capistrano
lock '~> 3.11.0'

set :application, 'staff'

# Default value for :format is :airbrussh.
set :format, :pretty

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
append :linked_files, 'config/mongoid.yml', '.env', '.yarnrc'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', '.bundle'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

set :npm_roles, :web
set :npm_flags, '--silent --no-progress'

set :bundle_roles, :api

set :puma_role, :api

after 'deploy:published', 'staff:build'
after 'deploy:finished', 'pm2:reload'
