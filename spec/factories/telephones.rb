require 'spec_helper'

FactoryBot.define do

  factory :telephones, class: 'Phones' do
    phone_w_type { {"internal" => [Faker::Number.number(4)],
                    "local" =>    [Faker::Number.number(11)]}
    }
  end

end
