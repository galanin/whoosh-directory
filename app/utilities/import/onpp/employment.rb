module Utilities
  module Import
    module ONPP
      class Employment

        attr_accessor :external_id,
                      :person_external_id,
                      :unit_external_id,
                      :post_title,
                      :post_category_code,
                      :office, :building,
                      :phones,
                      :lunch_begin, :lunch_end,
                      :parental_leave,
                      :vacation_begin, :vacation_end,
                      :for_person_rank,
                      :in_unit_rank


        WORKING_TYPE_RANK = {
          'ОсновноеМестоРаботы'        => 0,
          'Совместительство'           => 1,
          'ВнутреннееСовместительство' => 2,
        }.freeze

        POST_CATEGORY_CODE = {
          'Руководители'            => 0,
          'Специалисты'             => 1,
          'Прочие служащие'         => 2,
          '*'                       => 2,
          'Основные рабочие'        => 3,
          'Вспомогательные рабочие' => 4,
        }.freeze

        def initialize(source_data)
          @external_id        = source_data['ID_M']
          @person_external_id = source_data['ID_FL']
          @unit_external_id   = source_data['ID_PODR']
          @post_title         = source_data['POST']
          @post_category_code = POST_CATEGORY_CODE[source_data['KAT']] || POST_CATEGORY_CODE['*']
          @office             = source_data['ROOM']
          @building           = normalize_building(source_data['KORP'])
          @phones             = normalize_phones(source_data['PHONE'])
          @lunch_begin        = source_data['OBED_TIME_B']
          @lunch_end          = source_data['OBED_TIME_E']
          @parental_leave     = source_data['IS_DEKRET'] == '1'
          @vacation_begin     = source_data['DATE_B_OTP']
          @vacation_end       = source_data['DATE_E_OTP']
          @for_person_rank    = WORKING_TYPE_RANK[source_data['VID_ZAN']] || 99
        end


        def may_add?
          !parental_leave
        end


        def attributes
          {
            external_id:        external_id,
            person_external_id: person_external_id,
            unit_external_id:   unit_external_id,
            post_title:         post_title,
            post_category_code: post_category_code,
            office:             office,
            phones:             phones,
            lunch_begin:        lunch_begin,
            lunch_end:          lunch_end,
            vacation_begin:     vacation_begin,
            vacation_end:       vacation_end,
            in_unit_rank:       in_unit_rank,
          }
        end


        BUILDING_CLEANUP = [
          /^корпус?\s*/i,
          /^корп\.\s*/i,
          /^копус\s*/i,
          /^кор\.\s*/i,
          /корпус$/,
          /[\"]/,
          /\(цех 61\)$/,
        ].freeze

        BUILDING_REPLACE = {
          /отчистные/                        => 'очистные',
          /очистные сооружения/              => 'очистные',
          /^фок$/i                           => 'ФОК',
          /^(\d+)\s*[\-\/\.]?\s*([АБВГДЕ])/i => '\1\2',
          /^№\s*(\d+)/                       => '\1',
          /^9$/                              => 'Гараж',
          /^к\.9 гараж$/                     => 'гараж',
          /^проходная северная$/             => 'северная проходная',
          /^А3$/                             => '3A',
          /^переход в к.3Б$/                 => 'переход 3Б',
          /^переход корпуса 3а в цех 94$/    => 'переход 3Б',
          /^переход из 3 А в цех 94$/        => 'переход 3Б',
          /^здание 101$/                     => '101',
          /^1, 5$/                           => '5',
          /^3-$/                             => '3А',
          /^ЗБ$/                             => '3Б',
          /^ЗЕ$/                             => '3Е',
          /ЗДОЛПолет/                        => 'Полет',
          /П\/ЛАГЕРЬ ПОЛЕТ/                  => 'Полет',
          /П\/ЛПОЛЕТ/                        => 'Полет',
          /п\/л ПОЛЁТ/                       => 'Полет',
          /б\/о Угра/                        => 'Угра',
        }.freeze

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
          /[\-\+]/                                               => '',
          /\s*гор\.$/                                            => '',
          /\s*моб\.? тел$/                                       => '',
          /\s*внутр\.$/                                          => '',
          /(?:39)?96868\s*\(доб\.\s*(\d\d)-?(\d\d)\)/            => '\1\2',
          /(?:8484)?39968687(\d{4})/                             => '\1',
          /^[78][\s\(]*(\d{3})[\s\)]*(\d{3})\s*(\d\d)\s*(\d\d)$/ => '8\1\2\3\4',
          /^76\d{3}$/                                            => '',
          /^[78]?4843996868$/                                    => '',
          /^3996868$/                                            => '',
          /^(9\d{9})$/                                           => '8\1',
        }.freeze

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
  end
end
