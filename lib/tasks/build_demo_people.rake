require 'dotenv/tasks'
require 'yaml'
require 'securerandom'

# run this task as: rake import[ONPP]

task :build_demo_people, [:count, :lang] => :environment do |task, args|
  require 'faker'

  Faker::Config.locale = (args[:lang] || :ru).to_sym
  count = (args[:count] || 10_000).to_i

  people = []
  count.times { people << build_person }

  puts people.to_yaml
end


def build_person
  person = {}

  person[:external_id] = SecureRandom.uuid

  person[:gender] = rand > 0.5 ? 'F' : 'M'

  if person[:gender] == 'F'
    person[:first_name] = Faker::Name.female_first_name
    person[:middle_name] = Faker::Name.female_middle_name
    person[:last_name] = Faker::Name.female_last_name
  else
    person[:first_name] = Faker::Name.male_first_name
    person[:middle_name] = Faker::Name.male_middle_name
    person[:last_name] = Faker::Name.male_last_name
  end

  birthday = Date.today - rand(40 * 365)
  person[:birthday] = birthday.strftime('%m-%d')

  person
end
