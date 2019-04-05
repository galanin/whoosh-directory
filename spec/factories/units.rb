require 'spec_helper'

FactoryBot.define do

  factory :unit do

    external_id { Faker::Lorem.unique.characters(10) }
    long_title { Faker::Commerce.department }
    short_title { long_title }
    list_title { long_title}
    child_ids { [] }
    employ_ids { [] }
    contact_ids { [] }
    level { [0, 1, 2, 3, 4].sample}
    alpha_sort {long_title}

    factory :org_unit do
      long_title { Faker::Company.name }
      short_title { long_title }
      list_title { long_title}
      type { "org" }
      level {0}
    end

    factory :div_unit do
      type { "div" }
    end

    factory :dep_unit do
      type { "dep" }
    end

    factory :sec_unit do
      type { "sec" }
    end

  end

end
