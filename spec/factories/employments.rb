require 'spec_helper'

FactoryBot.define do

  factory :employment do
    transient do
      unit_callback { true }
    end

    external_id {Faker::Lorem.unique.characters(10)}
    post_title { Faker::Job.title }
    post_code { %w(head specialist employee worker aux_worker).sample }
    is_manager { Faker::Boolean.boolean}
    is_boss { [true, nil].sample }
    office { Faker::Number.number(3)}
    building { Faker::Number.number(2)}
    lunch_begin { "12:20"}
    lunch_end { "13:08"}
    parental_leave { [nil, '1'].sample}
    vacation_begin { nil}
    vacation_end { nil }
    for_person_rank { nil}
    in_unit_rank { nil }
    alpha_sort { post_title }
    telephones { FactoryBot.build(:telephones)  }

    factory :manager do
      post_code { 'head' }
      is_manager { true }

      factory :director do
        post_title {'General director'}
      end
    end

    factory :specialist do
      post_code { %w(specialist employee worker aux_worker).sample }
      is_manager { false }
    end

    trait :with_unit do
      after :build do |employment|
        unit = create(:unit)
        unit.employ_ids << employment.short_id
        employment.unit = unit
        employment.unit_short_id = unit.short_id
        employment.unit_external_id = unit.external_id
      end
    end

    trait :with_person do
      after :build do |employment|
        person = create(:person)
        person.employ_ids << employment.short_id
        person.employ_ids
        person.save
        employment.person = person
        employment.person_short_id = person.short_id
        employment.person_external_id = person.external_id
      end
    end

    after :build do |employment, options|
      if options.unit_callback
        unit = employment.unit
        unit.employ_ids << employment.short_id
        employment.unit_short_id = unit.short_id
        employment.unit_external_id = unit.external_id
      end
    end

  end
end
