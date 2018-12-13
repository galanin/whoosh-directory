module FormatPhone
  extend ActiveSupport::Concern

  included do

    PHONES_TYPE = {
      /\A\d{2,3}\z/       =>  'emergency',
      /\A\d{4}\z/         =>  'internal',
      /\A79\d{9}\z/       =>  'mobile',
      /\A(\d{5,7})\z/     =>  'city',
      /\A(7[0-8]\d{9})\z/ =>  'city',
    }

    def format_phones_with_type
      unless phones.nil?
        phones.map do |phone|
          [phone, get_formatted_phone(phone), get_phone_type_label(phone)]
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

  end
end
