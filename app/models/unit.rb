class Unit < ApplicationRecord
  include Mongoid::Document
  include Mongoid::Timestamps
  include ShortId
  include Searchable

  field :external_id,  type: String
  field :long_title,   type: String
  field :short_title,  type: String
  field :list_title,   type: String
  field :child_ids,    type: Array
  field :employ_ids,   type: Array
  field :contact_ids,  type: Array
  field :level,        type: Integer
  field :destroyed_at, type: Time


  belongs_to :parent, class_name: 'Unit', optional: true

  has_many :employments
  has_many :external_contacts


  def as_json(options = nil)
    super.slice(
      'long_title', 'short_title', 'list_title',
      'child_ids', 'employ_ids', 'level',
    ).compact.merge(
      'id' => short_id,
    )
  end

end
