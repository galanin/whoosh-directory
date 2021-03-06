module Utilities
  module Import
    module ONPP
      class PersonData

        include Utilities::Import::Data


        GENDERS = {
          'Мужской' => 'M',
          'Женский' => 'F',
        }.freeze


        attr_accessor :external_id,
                      :first_name, :middle_name, :last_name,
                      :birthday, :hide_birthday,
                      :gender,
                      :email,
                      :employment_external_ids


        def initialize(source_data)
          @external_id    = source_data['ID_FL']
          @first_name     = source_data['I']
          @middle_name    = source_data['O']
          @last_name      = source_data['F']
          @birthday       = source_data['HIDE_DATE_R'] == '1' ? nil : normalize_birthday(source_data['DATE_R'])
          @gender         = GENDERS[source_data['SEX']]
          @email          = nil

          @employment_external_ids = []
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


        def cleanup_employments
          @employment_external_ids = []
        end


        def add_employment_data(employment_data)
          @employment_external_ids ||= []
          @employment_external_ids << employment_data.external_id
        end


        def cleanup_excess_employments(employment_collection)
          if @employment_external_ids.count > 1
            @employment_external_ids.sort_by! { |employment_id| employment_collection[employment_id].new_data.for_person_rank }
            @employment_external_ids[1 .. -1].each { |employment_id| employment_collection.remove_by_id(employment_id) }
            @employment_external_ids.slice!(1 .. -1)
          end
        end


        def inspect
          "UnitData '#{ long_title }'>"
        end


        private


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
