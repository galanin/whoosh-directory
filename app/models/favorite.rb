class Favorite < ApplicationRecord

  include Mongoid::Document
  include Mongoid::Timestamps

  field :favorable_short_id, type: String

  index({favorable_short_id: 1, favoritable_type: 1, updated_at: -1}, {})

  scope :with_employment, ->{ where(favoritable_type: "Employment").order(updated_at: :desc)}
  scope :with_unit, ->{ where(favoritable_type: "Unit").order(updated_at: :desc)}

  belongs_to :favoritable, polymorphic: true
  belongs_to :user_information

end
