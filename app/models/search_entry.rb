class SearchEntry < ApplicationRecord
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :searchable, polymorphic: true

  field :unit_id,     type: String # unit_short_id
  field :person_id,   type: String # person_short_id
  field :employ_ids,  type: Array # employment_short_ids
  field :contact_id,  type: String # external_contact_short_ids
  field :keywords,    type: Array
  field :weights,     type: Hash # keyword weights
  field :sub_order,   type: String # second sort field after final weight

  index(keywords: 1)


  def as_json(options = nil)
    super.slice('unit_id', 'person_id', 'employ_ids', 'contact_id').compact
  end


end
