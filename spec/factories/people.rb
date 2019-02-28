require 'spec_helper'

FactoryBot.define do

  factory :person do
    external_id {Faker::Lorem.unique.characters(10)}
    first_name { Faker::Name.first_name }
    middle_name {Faker::Name.middle_name}
    last_name { Faker::Name.last_name }
    birthday { Faker::Date.birthday(18, 80).strftime('%d-%m') }
    gender { %w(F M).sample}
    email { Faker::Internet.email }
    employ_ids { [] }
    destroyed_at { nil }

  end

end
