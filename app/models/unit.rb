class Unit < ApplicationRecord
  include Mongoid::Document
  include Mongoid::Timestamps
  include ShortId
  include Searchable
  include Importable
  include ImportableUnit

  field :long_title,   type: String
  field :short_title,  type: String
  field :node_short_id,type: String
  field :head_short_id,type: String
  field :alpha_sort,   type: String
  field :destroyed_at, type: Time

  belongs_to :node
  belongs_to :head, class_name: 'Employment', optional: true

  scope :api_fields, -> { only(:short_id, :long_title, :short_title, :alpha_sort, :node_short_id, :head_short_id) }
  index({ destroyed_at: 1, short_id: 1 }, {})


  def as_json(options = nil)
    super.slice(
      'long_title', 'short_title', 'alpha_sort',
    ).compact.merge(
      'id' => short_id,
      'node_id' => node_short_id,
      'head_id' => head_short_id,
    )
  end

end
