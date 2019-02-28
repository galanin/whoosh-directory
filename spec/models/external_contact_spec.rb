require 'spec_helper'

describe ExternalContact, type: :model do
  let(:contact) { FactoryBot.create :external_contact_person, :with_unit  }

  it { is_expected.to be_mongoid_document }
  it { is_expected.to have_timestamps }

  it { is_expected.to belong_to(:unit) }
  it { is_expected.to embed_one(:telephones) }

  it { should validate_presence_of :external_id }

  it { is_expected.to validate_uniqueness_of(:short_id) }

  it ".as_json short_id" do
    expect(contact.as_json["id"]).to eq(contact.short_id)
    expect(contact.as_json["unit_id"]).to eq(contact.unit.short_id)
  end

end
