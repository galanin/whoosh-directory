require 'carrierwave/mongoid'

class Person < ApplicationRecord
  include Mongoid::Document
  include Mongoid::Timestamps
  include ShortId

  field :external_id,     type: String
  field :first_name,      type: String
  field :middle_name,     type: String
  field :last_name,       type: String
  field :birthday,        type: String
  field :gender,          type: String
  field :employ_ids,      type: Array
  field :destroyed_at,    type: Time


  has_many :employments

  mount_uploader :photo, PersonPhotoUploader
  field :photo_updated_at, type: Time


  scope :api_fields, -> { only(:short_id, :first_name, :middle_name, :last_name,
                               :birthday, :gender) }


  def as_json(options = nil)
    super.slice(
      'first_name', 'middle_name', 'last_name',
      'birthday', 'gender', 'photo',
    ).merge(
      'id' => short_id,
    )
  end

end
