class Employment < ApplicationRecord
  include Mongoid::Document
  include Mongoid::Timestamps
  include ShortId
  include Searchable

  field :external_id,        type: String
  field :person_external_id, type: String
  field :unit_external_id,   type: String
  field :person_short_id,    type: String
  field :unit_short_id,      type: String
  field :post_title,         type: String
  field :post_category_code, type: String
  field :office,             type: String
  field :building,           type: String
  field :phones,             type: Array
  field :lunch_begin,        type: String
  field :lunch_end,          type: String
  field :parental_leave,     type: Boolean
  field :vacation_begin,     type: Date
  field :vacation_end,       type: Date
  field :for_person_rank,    type: Integer
  field :in_unit_rank,       type: Integer
  field :destroyed_at,       type: Time

  validates :external_id, :person_external_id, :unit_external_id, :person_short_id, :unit_short_id, :post_title, presence: true

  belongs_to :person
  belongs_to :unit


  PHONES_TYPE = {
    /\A\d{3,4}\z/       =>  'internal',
    /\A79\d{9}\z/       =>  'mobile',
    /\A(\d{5,7})\z/     =>  'city',
    /\A(7[0-8]\d{9})\z/ =>  'city',
  }


  def as_json(options = nil)
    result = super.slice(
      'post_title', 'post_category_code',
      'office', 'building', 'phones',
      'lunch_begin', 'lunch_end',
    ).compact.merge(
      'id'          => short_id,
      'person_id'   => person_short_id,
      'unit_id'     => unit_short_id,
      'format_phones' => format_phones_with_type,
    )
    result.merge!('on_vacation' => true) if on_vacation

    result
  end


  def format_phones_with_type
    new_phones = unless phones.nil?
      phones.map do |phone|
        phone_patterns = I18n.t("phones.patterns")

        phone_pattern_hash = phone_patterns.values.find do |pattern_hash|
        phone =~ ::Regexp.new(pattern_hash[:regexp])
        end

        new_phone = phone.gsub(::Regexp.new(phone_pattern_hash[:regexp]), phone_pattern_hash[:format])
        phone_type_label = I18n.t("phones.type.#{get_phone_type(phone)[1]}")

        [new_phone, phone_type_label]
      end
    end

    new_phones
  end


  def get_phone_type(phone)
    PHONES_TYPE.find do |phone_type_hash|
      phone =~ phone_type_hash[0]
    end
  end


  def on_vacation
    today = Date.today
    vacation_begin && vacation_end && today >= vacation_begin && today <= vacation_end
  end

end
