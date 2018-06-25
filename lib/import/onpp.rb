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
    end
    
    
    private


    def import_units
      @new_units ||= @doc.xpath('.//organization').map do |org|
        @import.unit_cache.import(
            id:          org['ID'],
            long_title:  org['FULLNAME'],
            short_title: org['NAME'],
            list_title:  org['FULLNAME'].length > 60 ? (org['NAME'].presence || org['FULLNAME']) : (org['FULLNAME'].presence || org['NAME']),
            path:        org['HASH'],
            parent_id:   org['UP_ID'],
            )
      end
    end


    GENDERS = {
        'Мужской' => 'M',
        'Женский' => 'F',
    }

    def import_people
      @new_people ||= @doc.xpath('.//person').map do |person|
        @import.person_cache.import(
            id:            person['ID_FL'],
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
        @import.employment_cache.import(
            id:                person['ID_M'],
            person_id:         person['ID_FL'],
            post:              person['POST'],
            unit_id:           person['ID_PODR'],
            dept_id:           person['ID_STRUCT_PODR'],
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
