task :full_import, %i[source language] => :environment do |task, args|
  language = args[:language] || :ru

  importer = "Utilities::Import::#{args[:source]}::Importer".constantize.new
  importer.import(language: language)
  Utilities::Import::SearchIndex.rebuild
end
