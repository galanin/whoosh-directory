task :full_import, [:source] => :environment do |task, args|
  importer = "Utilities::Import::#{args[:source]}::Importer".constantize.new
  importer.import
  Utilities::Import::SearchIndex.rebuild
end
