require 'spec_helper'

describe Employment, type: :model do
  let(:employment) { FactoryBot.create :employment, :with_unit, :with_person  }

  it { is_expected.to be_mongoid_document }
  it { is_expected.to have_timestamps }

  it { is_expected.to belong_to(:person) }
  it { is_expected.to belong_to(:unit) }
  it { is_expected.to embed_one(:telephones) }

  it { should validate_presence_of :external_id }
  it { should validate_presence_of :person_external_id }
  it { should validate_presence_of :unit_external_id }
  it { should validate_presence_of :person_short_id }
  it { should validate_presence_of :unit_short_id }
  it { should validate_presence_of :post_title }

  it { is_expected.to validate_uniqueness_of(:short_id) }

  it ".as_json short_id" do
    expect(employment.as_json["id"]).to eq(employment.short_id)
    expect(employment.as_json["person_id"]).to eq(employment.person.short_id)
    expect(employment.as_json["unit_id"]).to eq(employment.unit.short_id)
  end

end
