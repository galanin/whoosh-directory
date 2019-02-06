class Favorite < ApplicationRecord

  include Mongoid::Document
  include Mongoid::Timestamps
  include ShortId

  field :favorable_short_id, type: String

  belongs_to :favoritable, polymorphic: true
  embedded_in :user_information





end
