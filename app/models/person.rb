require 'carrierwave/mongoid'

class Person < ApplicationRecord
  include Mongoid::Document
  include Mongoid::Timestamps
  include ImportEntity

  field :_id,             type: String
  field :first_name,      type: String
  field :middle_name,     type: String
  field :last_name,       type: String
  field :birthday,        type: String
  field :hide_birthday,   type: Boolean
  field :gender,          type: String
  field :employment_ids,  type: Array


  has_many   :employments

  mount_uploader :photo, PersonPhotoUploader
  field :photo_updated_at, type: Time

end
