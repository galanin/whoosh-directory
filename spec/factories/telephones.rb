require 'spec_helper'

FactoryBot.define do

  factory :telephones, class: 'Phones' do
    phone_w_type { {"internal" => [Faker::Number.number(4)]} }
  end

end
