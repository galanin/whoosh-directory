class Unit < ApplicationRecord
  include Mongoid::Document
  include Mongoid::Timestamps
  include ShortId
  include Searchable
  include Importable

  field :long_title,   type: String
  field :short_title,  type: String
  field :list_title,   type: String
  field :node_short_id,type: String
  field :alpha_sort,   type: String
  field :destroyed_at, type: Time

  belongs_to :node

  index({ destroyed_at: 1, short_id: 1 }, {})


  def as_json(options = nil)
    super.slice(
      'long_title', 'short_title', 'alpha_sort', 'list_title',
      'child_ids', 'employ_ids', 'contact_ids', 'level',
    ).compact.merge(
      'id' => short_id,
    )
  end

end
