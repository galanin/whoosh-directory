require 'dotenv/tasks'

# run this task as: rake rebuild_index

task :rebuild_index => :environment do
  search_index = Utilities::Import::SearchIndex.new

  Unit.where(destroyed_at: nil).each do |unit|
    search_index.add_object(unit)
  end
  Person.where(destroyed_at: nil).each do |person|
    search_index.add_object(person)
  end
  Employment.where(destroyed_at: nil).each do |employment|
    search_index.add_object(employment)
  end

  search_index.update!
end
