I18n.load_path << Dir[File.expand_path('config/locales') + '/*.yml']
I18n.available_locales = [:en, :ru]
I18n.default_locale = :ru
I18n.fallbacks[:ru] = [:ru, :en]
