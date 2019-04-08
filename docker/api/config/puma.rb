#!/usr/bin/env puma

rackup      DefaultRackup
tag         'staff_production'
directory   '/api'
environment 'production'
state_path  '/var/run/puma.state'
pidfile     '/var/run/puma.pid'

# stdout_redirect '/var/log/puma-stdout.log', '/var/log/puma-stderr.log'

threads 2, 5

port ENV['API_PORT']

workers 2
worker_timeout 5000

preload_app!

on_restart do
  puts 'Refreshing Gemfile'
  ENV['BUNDLE_GEMFILE'] = '/api/Gemfile'
end

before_fork do
  require 'puma_worker_killer'

  PumaWorkerKiller.config do |config|
    config.ram           = 512 # mb
    config.frequency     = 5    # seconds
    config.percent_usage = 0.90
    config.rolling_restart_frequency = 6 * 3600 # in seconds
    config.reaper_status_logs = false # setting this to false will not log lines like:
    # PumaWorkerKiller: Consuming 54.34765625 mb with master and 2 workers.

    config.pre_term = -> (worker) { puts "Worker #{worker.inspect} being killed" }
  end

  PumaWorkerKiller.start
end
