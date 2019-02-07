class Favorite < ApplicationRecord

  include Mongoid::Document
  include Mongoid::Timestamps
  include ShortId

  field :favorable_short_id, type: String

  scope :with_employment, ->{ where(favoritable_type: "Employment").order(updated_at: :desc)}
  scope :with_unit, ->{ where(favoritable_type: "Unit").order(updated_at: :desc)}

  belongs_to :favoritable, polymorphic: true
  embedded_in :user_information

end
