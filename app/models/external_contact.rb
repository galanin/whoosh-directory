require 'carrierwave/mongoid'
require 'i18n'
require 'date'

class ExternalContact < ApplicationRecord
  include Mongoid::Document
  include Mongoid::Timestamps
  include ShortId
  include Searchable
  include FormatPhone
  include FormatBirthday

  field :external_id,       type: String
  field :unit_external_id,  type: String
  field :unit_short_id,     type: String
  field :first_name,        type: String
  field :middle_name,       type: String
  field :last_name,         type: String
  field :birthday,          type: String
  field :gender,            type: String
  field :post_title,        type: String
  field :post_code,         type: String
  field :function_title,    type: String
  field :location_title,    type: String
  field :office,            type: String
  field :building,          type: String
  field :phones,            type: Array
  field :email,             type: String
  field :destroyed_at,      type: Time


  validates :external_id, :phones, presence: true

  belongs_to :unit

  mount_uploader :photo, PersonPhotoUploader
  field :photo_updated_at, type: Time

  index({ destroyed_at: 1, birthday: 1 }, {})


  def as_json(options = nil)
    json = super.slice(
      'first_name', 'middle_name', 'last_name',
      'birthday', 'post_title', 'post_code', 'office',
      'building', 'phones', 'photo', 'email',
      'gender', 'function_title', 'location_title',
    ).compact.merge(
      'id'          => short_id,
      'unit_id'     => unit_short_id,
      'format_phones' => format_phones_with_type,
    )

    if birthday.present?
      json.merge!('birthday_formatted' => birthday_formatted)
    end

    json
  end


  def person?
    last_name.present?
  end


  def function?
    function_title.present?
  end


  def location?
    location_title.present?
  end


  def sorting_title
    if person?
      "#{last_name} #{first_name} #{middle_name}".squish
    elsif function?
      function_title
    elsif location?
      location_title
    end
  end

end
