ENV['RACK_ENV'] ||= 'test'

require 'ostruct'
require 'factory_bot'
require 'mongoid_cleaner'
require 'carrierwave/mongoid'
require 'faker'
require 'mongoid-rspec'

Mongoid.load!('config/mongoid.yml')

# Load our application
require_relative '../api.rb'
# Load factories
require_relative './factories/employments.rb'
require_relative './factories/external_contacts.rb'
require_relative './factories/people.rb'
require_relative './factories/telephones.rb'
require_relative './factories/units.rb'
# Load helper
require_relative './support/helpers.rb'

RSpec.configure do |config|

  config.include Helpers

  config.before(:suite) do
    I18n.available_locales = [:en, :ru]
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
