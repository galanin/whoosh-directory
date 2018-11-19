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
                      :email,
                      :employment_ids


        def initialize(source_data)
          @external_id    = source_data['ID_FL']
          @first_name     = source_data['I']
          @middle_name    = source_data['O']
          @last_name      = source_data['F']
          @birthday       = source_data['HIDE_DATE_R'] == '1' ? nil : normalize_birthday(source_data['DATE_R'])
          @gender         = GENDERS[source_data['SEX']]
          @employment_ids = []
          @email          = nil
        end


        def attributes
          {
            external_id: external_id,
            first_name:  first_name,
            middle_name: middle_name,
            last_name:   last_name,
            birthday:    birthday,
            gender:      gender,
            email:       email,
          }
        end


        def normalize_birthday(raw_str)
          if raw_str.present?
            day, month = raw_str.split('.')
            if month.present?
              month + '-' + day
            end
          end
        end

      end
    end
  end
end
