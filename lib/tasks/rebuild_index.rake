require 'dotenv/tasks'

# run this task as: rake rebuild_index

task :rebuild_index => :environment do
  Utilities::Import::SearchIndex.rebuild
end
