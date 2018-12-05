#!/usr/bin/env puma

rackup      DefaultRackup
tag         'staff_production'
directory   '/home/deployer/staff_production/current'
environment 'production'
state_path  '/home/deployer/staff_production/shared/tmp/pids/puma.state'
pidfile     '/home/deployer/staff_production/shared/tmp/pids/puma.pid'

stdout_redirect '/home/deployer/staff_production/shared/log/puma-stdout.log', '/home/deployer/staff_production/shared/log/puma-stderr.log'

threads 2, 5

port 8002

workers 2
worker_timeout 5000

preload_app!

on_restart do
  puts 'Refreshing Gemfile'
  ENV['BUNDLE_GEMFILE'] = '/home/deployer/staff_production/current/Gemfile'
end

before_fork do
  require 'puma_worker_killer'

  PumaWorkerKiller.config do |config|
    config.ram           = 512 # mb
    config.frequency     = 5    # seconds
    config.percent_usage = 0.90
    config.rolling_restart_frequency = 6 * 3600 # in seconds
    config.reaper_status_logs = true # setting this to false will not log lines like:
    # PumaWorkerKiller: Consuming 54.34765625 mb with master and 2 workers.

    config.pre_term = -> (worker) { puts "Worker #{worker.inspect} being killed" }
  end
  PumaWorkerKiller.start
end
