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
append :linked_files, 'config/mongoid.yml', '.env'

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


namespace :npm do

  task :build do
    on roles(:web) do
      within release_path do
        execute :npm, 'run prod:build'
      end
    end
  end

end


namespace :pm2 do

  task :reload do
    on roles(:web) do
      within release_path do
        execute :pm2, 'reload /home/deployer/staff_production/shared/ecosystem.config.js --env production'
      end
    end
  end

end


after 'npm:install', 'npm:build'
after 'npm:build', 'pm2:reload'
after 'npm:build', 'puma:restart'
