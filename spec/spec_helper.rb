ENV['RACK_ENV'] ||= 'test'

require 'ostruct'
require 'factory_bot'
require 'mongoid_cleaner'
require 'carrierwave/mongoid'
require 'faker'
require 'mongoid-rspec'
require 'rack/test'

Mongoid.load!('config/mongoid.yml')

# Load our application
require_relative '../api.rb'
# Load factories
Dir["./spec/factories/*.rb"].sort.each { |f| require f }
# Load helpers
Dir["./spec/support/**/*.rb"].sort.each { |f| require f }

RSpec.configure do |config|

  config.include Helpers
  config.include StructureHelper

  config.before(:suite) do
    I18n.available_locales = [:en, :ru]
    I18n.default_locale = :ru
    I18n.reload!
    Faker::Config.locale = :en
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.include FactoryBot::Syntax::Methods

  config.include Mongoid::Matchers

  # Setup Mongoid Cleaner to clean everything before
  # and between each test
  config.before(:suite) do
    MongoidCleaner.strategy = :drop
  end

  config.around(:each) do |example|
    MongoidCleaner.cleaning do
      example.run
    end
  end
end
