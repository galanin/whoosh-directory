require 'dotenv/tasks'

# run this task as: rake import[ONPP,ru]
# run this task as: rake import[Demo,ru]

task :import, %i[source language] => :environment do |task, args|
  language = args[:language] || :ru

  importer = "Utilities::Import::#{args[:source]}::Importer".constantize.new
  importer.import(language: language)
end
