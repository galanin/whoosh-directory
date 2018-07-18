# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/boot'
require 'rake'
require 'bundler'
# Bundler.setup

desc 'load the Grape environment.'
task :environment do
  require File.expand_path('api', File.dirname(__FILE__))
end

$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')

Dir["#{File.dirname(__FILE__)}/lib/**/*.rb"].each { |f| require f }
Dir["#{File.dirname(__FILE__)}/lib/tasks/**/*.rake"].each { |f| import f }
