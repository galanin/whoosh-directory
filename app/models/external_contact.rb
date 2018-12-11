require 'carrierwave/mongoid'
require 'i18n'
require 'date'

class ExternalContact < ApplicationRecord
  include Mongoid::Document
  include Mongoid::Timestamps
  include ShortId
  include Searchable

  field :external_id,       type: String
  field :unit_external_id,  type: String
  field :unit_short_id,     type: String
  field :first_name,        type: String
  field :middle_name,       type: String
  field :last_name,         type: String
  field :birthday,          type: String
  field :post_title,        type: String
  field :office,            type: String
  field :building,          type: String
  field :phones,            type: Array
  field :email,             type: String
  field :destroyed_at,      type: Time


  validates :external_id, :phones, presence: true

  belongs_to :unit

  mount_uploader :photo, PersonPhotoUploader
  field :photo_updated_at, type: Time


  INPUT_BIRTHDAY_FORMAT = '%m-%d'


  def as_json(options = nil)
    super.slice(
      'first_name', 'middle_name', 'last_name',
      'birthday',  'post_title', 'office',
      'building', 'phones', 'photo', 'email',
    ).compact.merge(
      'id'          => short_id,
      'unit_id'     => unit_short_id,
    ).merge(
       'birthday_formatted' => (I18n.l(Date.strptime(birthday, INPUT_BIRTHDAY_FORMAT), format: :bithday) unless birthday.nil?)
    )
  end

end
