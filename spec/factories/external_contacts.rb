require 'spec_helper'

FactoryBot.define do

  factory :external_contact do
    external_id { Faker::Lorem.unique.characters(10) }
    gender { %w(F M).sample}
    post_code { %w(head specialist employee worker aux_worker).sample }
    destroyed_at { nil }
    telephones { FactoryBot.build(:telephones)  }

    factory :external_contact_person do
      first_name { Faker::Name.first_name }
      middle_name {Faker::Name.middle_name}
      last_name { Faker::Name.last_name }
      birthday { Faker::Date.birthday(18, 80).strftime('%m-%d') }
      post_title { Faker::Job.title }
      office { Faker::Number.number(3)}
      building { Faker::Number.number(2)}
      email { Faker::Internet.email }
      alpha_sort { first_name + middle_name + last_name}
    end

    factory :external_contact_function do
      function_title { Faker::Job.title }
    end

    factory :external_contact_location_title do
      location_title { Faker::Commerce.department }
    end

    trait :with_unit do
      after :build do |external_contact|
        unit = create(:unit)
        unit.contact_ids << external_contact.short_id
        external_contact.unit = unit
        external_contact.unit_short_id = unit.short_id
        external_contact.unit_external_id = unit.external_id
      end
    end

  end

end
