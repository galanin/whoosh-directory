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

  end

end
