require 'carrierwave/mongoid'
require 'i18n'

class Person < ApplicationRecord
  include Mongoid::Document
  include Mongoid::Timestamps
  include ShortId
  include Searchable
  include FormattableBirthday
  include Importable

  field :first_name,      type: String
  field :middle_name,     type: String
  field :last_name,       type: String
  field :birthday,        type: String
  field :gender,          type: String
  field :email,           type: String
  field :employ_ids,      type: Array # employment_short_ids
  field :destroyed_at,    type: Time

  validates :first_name, :last_name, presence: true

  has_many :employments

  mount_uploader :photo, PersonPhotoUploader
  field :photo_updated_at, type: Time


  scope :api_fields, -> { only(:short_id, :first_name, :middle_name, :last_name,
                               :birthday, :gender, :employ_ids) }

  index({ destroyed_at: 1, birthday: 1 }, {})
  index({ destroyed_at: 1, short_id: 1 }, {})


  def as_json(options = nil)
    json = super.slice(
      'first_name', 'middle_name', 'last_name',
      'birthday', 'gender', 'photo', 'email', 'employ_ids'
    ).compact.merge(
      'id' => short_id,
    )

    if birthday.present?
      json.merge!('birthday_formatted' => birthday_formatted(birthday))
    end

    json
  end


  def sorting_title
    "#{last_name} #{first_name} #{middle_name}".squish
  end

end
