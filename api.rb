require_relative 'config/boot'

# require "rails"
# Pick the frameworks you want:
# require "active_model/railtie"
# require "active_job/railtie"
# require "active_record/railtie"
# require "action_controller/railtie"
# require "action_mailer/railtie"
# require "action_view/railtie"
# require "action_cable/engine"
# require "sprockets/railtie"

require 'i18n'
I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)

require 'mongoid'
require 'autoinc'
require 'hashids'
require 'grape'
require 'json'
require_relative 'version'

$: << File.join(File.dirname(__FILE__), 'app')

Dir["#{File.dirname(__FILE__)}/config/initializers/*.rb"].each { |f| require f }
Dir["#{File.dirname(__FILE__)}/app/uploaders/**/*.rb"].each { |f| require f }
Dir["#{File.dirname(__FILE__)}/app/models/concerns/**/*.rb"].each { |f| require f }
require_relative 'app/models/application_record'
Dir["#{File.dirname(__FILE__)}/app/models/**/*.rb"].each { |f| require f }
Dir["#{File.dirname(__FILE__)}/app/utilities/*.rb"].each { |f| require f }
Dir["#{File.dirname(__FILE__)}/app/utilities/import/*.rb"].each { |f| require f }
Dir["#{File.dirname(__FILE__)}/app/utilities/**/*.rb"].each { |f| require f }
Dir["#{File.dirname(__FILE__)}/app/helpers/**/*.rb"].each { |f| require f }

Dir["#{File.dirname(__FILE__)}/app/apis/modules/**/*.rb"].each { |f| require f }

require_relative 'app/apis/version1'
