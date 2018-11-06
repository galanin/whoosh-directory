#!/usr/bin/env puma

rackup      DefaultRackup
tag         'staff_production'
directory   '/home/deployer/staff_production/current'
environment 'production'
state_path  '/home/deployer/staff_production/shared/tmp/pids/puma.state'
pidfile     '/home/deployer/staff_production/shared/tmp/pids/puma.pid'

stdout_redirect '/home/deployer/staff_production/shared/log/puma-stdout.log', '/home/deployer/staff_production/shared/log/puma-stderr.log'

threads 2, 10

port 8002

#workers 1
#worker_timeout 5000

preload_app!

on_restart do
  puts 'Refreshing Gemfile'
  ENV['BUNDLE_GEMFILE'] = '/home/deployer/staff_production/current/Gemfile'
end
