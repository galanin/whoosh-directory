class Phones < ApplicationRecord
  include Mongoid::Document
  include ShortId

  field :phone_w_type, type: Hash
  # phone_w_type is a Hash where key is type of phone number(phone_type) and value is Array of phone number strings(phone_str)
  # {phone_type: [phone_str1, phone_str2]}
  # phone_type:
  # - emergency
  # - emergency_mobile
  # - internal
  # - local
  # - mobile
  # - unknown
  # phone_str for mobile and local must be with country prefix
  # Example: {'local': ['74957777777'], 'mobile': ['79101234567', '79109876543']}

  embedded_in :phonable, polymorphic: true


  def format_phones_with_type
    result = []
    phone_w_type.each do |type, phones_array|
      phone_type_hash = I18n.t("phones.types.#{type}")
      translate_type = phone_type_hash[:name]

      phones_array.each do |phone_number|
        if phone_type_hash.has_key?(:regexp)
          formatted_phone = phone_number.gsub(::Regexp.new(phone_type_hash[:regexp]), phone_type_hash[:format])
        else
          formatted_phone = phone_number
        end
        result.push [phone_number, formatted_phone, translate_type]
      end
    end
    result
  end

end
