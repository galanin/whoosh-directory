class FavoriteUnit < ApplicationRecord

  include Mongoid::Document
  include Mongoid::Timestamps

  field :unit_short_id,      type: String
  field :alpha_sort,         type: String

  index({unit_short_id: 1}, {})

  belongs_to :unit
  embedded_in :user_information


  def as_json(options = nil)
    {
      'alpha_sort' => alpha_sort,
      'unit_id' => unit_short_id,
    }
  end

end
