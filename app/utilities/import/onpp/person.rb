module Utilities
  module Import
    module ONPP
      class Person

        GENDERS = {
          'Мужской' => 'M',
          'Женский' => 'F',
        }.freeze


        attr_accessor :external_id,
                      :first_name, :middle_name, :last_name,
                      :birthday, :hide_birthday,
                      :gender,
                      :employment_ids


        def initialize(source_data)
          @external_id    = source_data['ID_FL']
          @first_name     = source_data['I']
          @middle_name    = source_data['O']
          @last_name      = source_data['F']
          @birthday       = source_data['HIDE_DATE_R'] == '1' ? nil : normalize_birthday(source_data['DATE_R'])
          @gender         = GENDERS[source_data['SEX']]
          @employment_ids = []
        end


        def attributes
          {
            external_id: external_id,
            first_name:  first_name,
            middle_name: middle_name,
            last_name:   last_name,
            birthday:    birthday,
            gender:      gender,
          }
        end


        def normalize_birthday(raw_str)
          day, month = raw_str.split('.')
          month + '-' + day
        end

      end
    end
  end
end
