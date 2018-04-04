require 'import'

class Import
  class ONPP
    
    def initialize(import, xml_str)
      @import = import
      @doc = Nokogiri::XML(xml_str, nil, 'CP1251')
    end
    
    
    def execute
      import_units
      import_people
      import_employments

      build_structure
    end
    
    
    private


    def unit_index_by_uuid
      @unit_index_by_uuid ||= @import.unit_cache.index_by(&:uuid)
    end


    def person_index_by_uuid
      @person_index_by_uuid ||= @import.person_cache.index_by(&:uuid)
    end


    def employment_index_by_uuid
      @employment_index_by_uuid ||= @import.employment_cache.index_by(&:uuid)
    end


    def import_unit(field_values)
      (unit_index_by_uuid[field_values[:uuid]] ||= @import.create_unit(field_values)).
          tap { |u| u.write_attributes(field_values); u.imported! }
    end


    def import_person(field_values)
      (person_index_by_uuid[field_values[:uuid]] ||= @import.create_person(field_values)).
          tap { |p| p.write_attributes(field_values); p.imported! }
    end


    def import_employment(field_values)
      (employment_index_by_uuid[field_values[:uuid]] ||= @import.create_employment(field_values)).
          tap { |e| e.write_attributes(field_values); e.imported! }
    end


    def import_units
      @new_units ||= @doc.xpath('.//organization').map do |org|
        import_unit(
            uuid:        org['ID'],
            title:       org['FULLNAME'],
            short:       org['NAME'],
            path:        org['HASH'],
            parent_uuid: org['UP_ID'],
            )
      end
    end


    GENDERS = {
        'Мужской' => 'M',
        'Женский' => 'F',
    }

    def import_people
      @new_people ||= @doc.xpath('.//person').map do |person|
        import_person(
            uuid:          person['ID_FL'],
            first_name:    person['I'],
            middle_name:   person['O'],
            last_name:     person['F'],
            birthday:      person['DATE_R'],
            hide_birthday: person['HIDE_DATE_R'],
            gender:        GENDERS[person['SEX']],
            )
      end
    end


    WORKING_TYPE_PRIO = {
        'ОсновноеМестоРаботы'        => 0,
        'Совместительство'           => 1,
        'ВнутреннееСовместительство' => 2,
    }.freeze

    def import_employments
      @new_employments ||= @doc.xpath('.//person').map do |person|
        import_employment(
            uuid:              person['ID_M'],
            person_uuid:       person['ID_FL'],
            post:              person['POST'],
            unit_uuid:         person['ID_PODR'],
            dept_uuid:         person['ID_STRUCT_PODR'],
            number:            person['TN'].to_i,
            category:          person['KAT'],
            office:            person['ROOM'],
            building:          normalize_building(person['KORP']),
            phones:            normalize_phones(person['PHONE']),
            lunch_begin:       person['OBED_TIME_B'],
            lunch_end:         person['OBED_TIME_E'],
            parental_leave:    person['IS_DEKRET'],
            vacation:          person['IS_OTP'],
            vacation_begin:    person['DATE_B_OTP'],
            vacation_end:      person['DATE_E_OTP'],
            working_type:      person['VID_ZAN'],
            working_type_prio: WORKING_TYPE_PRIO[person['VID_ZAN']] || 99,
            )
      end
    end


    def build_structure
      @new_units.each do |unit|
        unit.parent = unit_index_by_uuid[unit.parent_uuid]
      end
      @new_employments.each do |employment|
        employment.person = person_index_by_uuid[employment.person_uuid]
        employment.unit   = unit_index_by_uuid[employment.unit_uuid]
        employment.dept   = unit_index_by_uuid[employment.dept_uuid]
      end
    end


    BUILDING_CLEANUP = [
        /^корпус?\s*/i,
        /^корп\.\s*/i,
        /^копус\s*/i,
        /^кор\.\s*/i,
        /корпус$/,
        /[\"]/,
        /\(цех 61\)$/,
    ]

    BUILDING_REPLACE = {
        /отчистные/ => 'очистные',
        /очистные сооружения/ => 'очистные',
        /^фок$/i => 'ФОК',
        /^(\d+)\s*[\-\/\.]?\s*([АБВГДЕ])/i => '\1\2',
        /^№\s*(\d+)/ => '\1',
        /^9$/ => 'Гараж',
        /^к\.9 гараж$/ => 'гараж',
        /^проходная северная$/ => 'северная проходная',
        /^А3$/ => '3A',
        /^переход в к.3Б$/ => 'переход 3Б',
        /^переход корпуса 3а в цех 94$/ => 'переход 3Б',
        /^переход из 3 А в цех 94$/ => 'переход 3Б',
        /^здание 101$/ => '101',
        /^1, 5$/ => '5',
        /^3-$/ => '3А',
        /^ЗБ$/ => '3Б',
        /^ЗЕ$/ => '3Е',
        /ЗДОЛПолет/ => 'Полет',
        /П\/ЛАГЕРЬ ПОЛЕТ/ => 'Полет',
        /П\/ЛПОЛЕТ/ => 'Полет',
        /п\/л ПОЛЁТ/ => 'Полет',
        /б\/о Угра/ => 'Угра',
    }

    def normalize_building(raw_str)
      result = raw_str.gsub(/\s+/, ' ')
      BUILDING_CLEANUP.each do |re|
        result.gsub!(re, '')
      end
      BUILDING_REPLACE.each do |re, replace|
        result.gsub!(re, replace)
      end
      if /^\d+[абвгде]$/ =~ result
        result.upcase!
      end
      result.strip
    end


    PHONES_REPLACE = {
        /[\-\+]/ => '',
        /\s*гор\.$/ => '',
        /\s*моб\.? тел$/ => '',
        /\s*внутр\.$/ => '',
        /(?:39)?96868\s*\(доб\.\s*(\d\d)-?(\d\d)\)/ => '\1\2',
        /(?:8484)?39968687(\d{4})/ => '\1',
        /^[78][\s\(]*(\d{3})[\s\)]*(\d{3})\s*(\d\d)\s*(\d\d)$/ => '7\1\2\3\4',
        /^76\d{3}$/ => '',
        /^[78]?4843996868$/ => '',
        /^(9\d{9})$/ => '7\1',
    }
    def normalize_phones(phones_str)
      result = phones_str.split(/[,;]\s*/)
      result.map! do |phone|
        phone_result = phone
        PHONES_REPLACE.each do |re, replace|
          phone_result.gsub!(re, replace)
        end
        phone_result.strip
      end
      result.uniq.select(&:present?)
    end

  end
end
