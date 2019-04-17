module Utilities
  module Import
    module ONPP
      class EmploymentData

        # attributes
        attr_accessor :external_id,
                      :post_title,
                      :post_code, :is_manager, :is_head,
                      :office, :building,
                      :telephones,
                      :lunch_begin, :lunch_end,
                      :parental_leave,
                      :vacation_begin, :vacation_end,
                      :for_person_rank,
                      :alpha_sort,
                      :in_unit_rank
        # relations
        attr_accessor :person_external_id,
                      :node_external_id, :department_node_external_id, :parent_node_external_id


        WORKING_TYPE_RANK = {
          'ОсновноеМестоРаботы'        => 0,
          'Совместительство'           => 1,
          'ВнутреннееСовместительство' => 2,
        }.freeze

        POST_CATEGORY_CODE = {
          'Руководители'            => 'manager',
          'Специалисты'             => 'engineer',
          'Прочие служащие'         => 'aux_employee',
          '*'                       => 'employee',
          'Основные рабочие'        => 'worker',
          'Вспомогательные рабочие' => 'aux_worker',
        }.freeze

        def initialize(source_data)
          @external_id        = source_data['ID_M']
          @person_external_id = source_data['ID_FL']
          @parent_node_external_id   = source_data['ID_PODR']
          @department_node_external_id = source_data['ID_STRUCT_PODR']
          @post_title         = source_data['POST']
          @post_code          = POST_CATEGORY_CODE[source_data['KAT']] || POST_CATEGORY_CODE['*']
          @is_manager         = @post_code == 'manager'
          @is_head            = is_head_post(source_data['POST'])
          @office             = normalize_office(source_data['ROOM'])
          @building           = normalize_building(source_data['KORP'])
          @telephones         = Phones.from_xml(source_data)
          @lunch_begin        = normalize_time(source_data['OBED_TIME_B'])
          @lunch_end          = normalize_time(source_data['OBED_TIME_E'])
          @parental_leave     = (source_data['IS_DEKRET'] == '1').presence
          @vacation_begin     = source_data['DATE_B_OTP'].presence
          @vacation_end       = source_data['DATE_E_OTP'].presence
          @for_person_rank    = WORKING_TYPE_RANK[source_data['VID_ZAN']] || 99
          @alpha_sort         = source_data['F'] + source_data['I'] + source_data['O']
        end


        def may_add?
          !parental_leave
        end


        def attributes
          {
            external_id:        external_id,
            post_title:         post_title,
            post_code:          post_code,
            is_manager:         is_manager,
            is_head:            is_head,
            building:           building,
            office:             office,
            lunch_begin:        lunch_begin,
            lunch_end:          lunch_end,
            vacation_begin:     vacation_begin,
            vacation_end:       vacation_end,
            alpha_sort:         alpha_sort,
            in_unit_rank:       in_unit_rank,
          }
        end


        def embedded_attributes
          {
            telephones: {
              attributes: telephones&.attributes,
            },
          }
        end


        OFFICE_REPLACE = {
          /б\/н/i => '',
          /з\/пункт/i => 'Здравпункт',
          /^(\d+)\s*-?\s*"?(\p{Word})"*$/ => '\1\2',
        }

        def normalize_office(raw_str)
          str = raw_str.to_s.strip
          str = OFFICE_REPLACE.reduce(str) { |str, (pattern, replacement)| str.sub(pattern, replacement) }
          str.presence
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
          result = raw_str.to_s.gsub(/\s+/, ' ')
          BUILDING_CLEANUP.each do |re|
            result.gsub!(re, '')
          end
          BUILDING_REPLACE.each do |re, replace|
            result.gsub!(re, replace)
          end
          if /^\d+[абвгде]$/ =~ result
            result.upcase!
          end
          result.strip.presence
        end


        def normalize_time(time_str)
          time_str.to_s.sub(/:\d\d$/, '').presence
        end



        POST_PRIORITY = [
          { post: /\bгенеральный директор\z/, priority: 0 },
          { post: /\bзаместитель генерального директора\b/, priority: 10 },
          { post: /\bдиректор\b/, priority: 20},
          { post: /\bглавный инженер\z/, priority: 20},
          { post: /\bпервый заместитель директора\b/, priority: 30 },
          { post: /\bзаместитель директора\b/, priority: 40 },
          { post: /\bглавный энергетик\z/, priority: 50 },
          { post: /\bглавный механик\z/, priority: 50 },
          { post: /\bглавный метролог\z/, priority: 50 },
          { post: /\bначальник\b/, priority: 60 },
          { post: /\bруководитель\b/, priority: 60 },
          { post: /\bзаведующий центральным складом\b/, priority: 60 },
          { post: /\bпервый заместитель\b/, priority: 70 },
          { post: /\bзаместитель\b/, priority: 80 },
          { post: /\bстарший мастер\b/, priority: 90 },
          { post: /\bмастер\b/, priority: 100 },
          { post: /\bсекретарь\b/, priority: 110 },

          { post: //, priority: 120 } # This record must be last item
        ]


        def employment_priority
          employment_post = post_title.downcase

          post_priority = POST_PRIORITY.find do |post|
            employment_post =~ post[:post]
          end

          post_priority && post_priority[:priority]
        end



        HEAD_POSTS = [
          /^начальник\b/,
        ]

        def is_head_post(post_title)
          HEAD_POSTS.any? { |re| post_title =~ re }
        end

      end
    end
  end
end
