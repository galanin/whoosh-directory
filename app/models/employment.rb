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
    unless phones.nil?
      phones.map do |phone|
        [get_formatted_phone(phone), get_phone_type_label(phone)]
      end
    end
  end


  def get_formatted_phone(phone_number)
    phone_patterns = I18n.t('phones.patterns')

    phone_pattern_hash = phone_patterns.values.find do |pattern_hash|
      phone_number =~ ::Regexp.new(pattern_hash[:regexp])
    end

    if phone_pattern_hash.present?
      phone_number.gsub(::Regexp.new(phone_pattern_hash[:regexp]), phone_pattern_hash[:format])
    else
      phone_number
    end
  end


  def get_phone_type_label(phone_number)
    pair = PHONES_TYPE.find do |phone_type_hash, _|
      phone_number =~ phone_type_hash
    end

    if pair.present?
      I18n.t(pair.second, scope: 'phones.type')
    else
      ''
    end
  end


  def on_vacation
    today = Date.today
    vacation_begin && vacation_end && today >= vacation_begin && today <= vacation_end
  end

end
