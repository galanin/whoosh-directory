require 'spec_helper'

describe Unit, type: :model do
  let(:unit) { FactoryBot.create :unit  }

  it { is_expected.to be_mongoid_document }
  it { is_expected.to have_timestamps }

  it { is_expected.to have_many :employments }
  it { is_expected.to have_many :external_contacts }
  it { is_expected.to belong_to(:parent) }

  it { is_expected.to validate_uniqueness_of(:short_id) }

  it ".as_json short_id" do
    expect(unit.as_json["id"]).to eq(unit.short_id)
  end

end
