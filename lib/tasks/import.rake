require 'dotenv/tasks'

# run this task as: rake import[ONPP]

task :import, [:source] => :environment do |task, args|
  importer = "Utilities::Import::#{args[:source]}::Importer".constantize.new
  importer.import
end
