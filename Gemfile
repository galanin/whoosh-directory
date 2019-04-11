source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rack'
gem 'grape'
gem 'grape-cli'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
# gem 'rails', '~> 5.1.5'
# gem 'actioncable', '~> 5.1.5'
# gem 'actionmailer', '~> 5.1.5'
# gem 'actionview', '~> 5.1.5'
gem 'activejob', '~> 5.1.5'
# gem 'activemodel', '~> 5.1.5'
gem 'activesupport', '~> 5.1.5'

# Use sqlite3 as the database for Active Record
gem 'mongoid'
gem 'mongoid-autoinc'
gem 'hashids'

# Use Puma as the app server
gem 'puma', '~> 3.7'
gem 'puma_worker_killer'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'nokogiri'
gem 'dotenv'
gem 'rake'
gem 'mini_magick'
gem 'carrierwave', '~> 1.2', require: 'carrierwave'
gem 'carrierwave-mongoid', require: 'carrierwave/mongoid'
gem 'i18n'
gem 'net-ldap'
gem 'whenever', require: false
gem 'write_xlsx'

gem 'faker'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rack-test'
  gem 'faker'
  gem "minitest"
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'rails_real_favicon'

  gem 'capistrano', '~> 3.11.0', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-yarn', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma', require: false
  gem 'capistrano-rails-console', require: false
  gem 'airbrussh', require: false
end

group :test do
  gem 'rspec'
  gem 'factory_bot'
  gem 'mongoid_cleaner'
  gem 'mongoid-rspec'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
