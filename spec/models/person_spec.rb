require 'spec_helper'

describe Person, type: :model do
  let(:person) { FactoryBot.create :person  }

  it { is_expected.to be_mongoid_document }
  it { is_expected.to have_timestamps }

  it { is_expected.to have_many :employments }

  it { should validate_presence_of :external_id }
  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }

  it { is_expected.to validate_uniqueness_of(:short_id) }

  it ".as_json short_id" do
    expect(person.as_json["id"]).to eq(person.short_id)
  end

end
