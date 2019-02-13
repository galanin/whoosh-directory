class FavoriteUnit < ApplicationRecord

  include Mongoid::Document
  include Mongoid::Timestamps

  field :unit_short_id,      type: String
  field :alpha_sort,         type: String

  index({unit_short_id: 1}, {})

  belongs_to :unit
  embedded_in :user_information


  def as_json(options = nil)
    super.slice('unit_short_id', 'alpha_sort').compact
  end

end
