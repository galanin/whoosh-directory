class FavoritePerson < ApplicationRecord

  include Mongoid::Document
  include Mongoid::Timestamps

  field :favorable_short_id,   type: String
  field :alpha_sort,           type: String

  index({favorable_short_id: 1, favoritable_type: 1, updated_at: -1}, {})

  scope :with_employment, -> { where(favoritable_type: "Employment")}
  scope :with_external_contact, -> { where(favoritable_type: "ExternalContact")}

  belongs_to :favoritable, polymorphic: true
  embedded_in :user_information



  def as_json(options = nil)
    json = { 'alpha_sort' => alpha_sort }
    json.merge!('employment_id' => favorable_short_id) if favoritable_type == 'Employment'
    json.merge!('contact_id' => favorable_short_id) if favoritable_type == 'ExternalContact'
    json
  end

end
