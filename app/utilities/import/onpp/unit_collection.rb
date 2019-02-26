require 'utilities/import/collection'

module Utilities
  module Import
    module ONPP
      class UnitCollection

        include Utilities::Import::Collection

        COMPANY_MANAGEMENT_PREFIX = 'Руководство предприятия'
        COMPANY_MANAGEMENT        = [
          {
            post_title: 'Генеральный директор',
            unit_title: 'Обнинское научно-производственное предприятие'
          },
          {
            post_title: 'Первый заместитель генерального директора',
            unit_title: 'Блок первого заместителя генерального директора'
          }
        ]

        MANAGEMENT_PREFIX = [/^Руководство/, /^Рук\./]

        #The element of constant POST_PRIORITY {post: //,  priority: max_number) must be last
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
          { post: /\bпервый заместитель\b/, priority: 70 },
          { post: /\bзаместитель\b/, priority: 80 },
          { post: /\bстарший мастер\b/, priority: 90 },
          { post: /\bмастер\b/, priority: 100 },
          { post: /\bсекретарь\b/, priority: 110 },
          { post: //, priority: 120 },
        ]


        def import_from_xml(doc)
          doc.xpath('.//organization').each do |org|
            unless present_in_black_list?(org['ID'])
              new_data = Utilities::Import::ONPP::Unit.new_from_xml(org)
              add_new_data(new_data)
            end
          end
        end


        def import_from_yaml(doc)
          doc.each do |org|
            new_data = Utilities::Import::ONPP::Unit.new_from_yml(org)
            add_new_data(new_data)
          end
        end


        def import_black_list(doc)
          doc.xpath('.//organization').map do |org|
            add_black_list(org['ID'])
          end
        end


        def reset_structure
          @entities.each do |id, unit_entity|
            unit_entity.new_data.child_ids = []
          end
        end


        def build_structure
          @entities.each do |id, unit_entity|
            parent = @entities[unit_entity.new_data.parent_external_id]
            parent.new_data.child_ids << id if parent.present?
          end
        end


        def sort_child_units
          @entities.each do |id, unit_entity|
            unit_entity.new_data.child_ids.sort_by! { |child_id| @entities[child_id].new_data.path }
          end
        end


        def set_priority(employment_unit_entity)
          employment_post = employment_unit_entity.new_data.post_title.downcase

          post_priority = POST_PRIORITY.find do |post|
            employment_post =~ post[:post]
          end

          {
            employment_id: employment_unit_entity.new_data.external_id,
            priority:      post_priority[:priority]
          }
        end



        def sort_employments(employment_collection)
          @entities.each do |id, unit_entity|
            unless unit_entity.new_data.employment_ids.nil?
              employment_ids = unit_entity.new_data.employment_ids
              employments = employment_collection.entities_by_ids(employment_ids)

              employments_with_priority = employments.map do |employment_unit|
                set_priority(employment_unit)
              end

              employments_with_priority.sort_by!{ |employment_with_priority| employment_with_priority[:priority] }
              unit_entity.new_data.employment_ids = employments_with_priority.map { |employment| employment[:employment_id] }
            end
          end
        end


        def set_bosses(employment_collection)
          @entities.each do |id, unit_entity|
            if unit_entity.new_data.employment_ids.present?
              first_employment_id = unit_entity.new_data.employment_ids.first
              first_employment_entity = employment_collection[first_employment_id]
              if first_employment_entity&.new_data.present? && first_employment_entity.new_data.is_manager
                first_employment_entity.new_data.is_boss = true
              end
            end
          end
        end


        def calc_levels
          @entities.each do |id, unit_entity|
            calc_unit_level(unit_entity)
          end
        end


        def link_objects_to_children_short_ids
          @entities.each do |id, unit_entity|
            if unit_entity.new_data
              unit_entity.old_object.child_ids = short_ids_by_external_ids(unit_entity.new_data.child_ids).presence
            end
          end
        end


        def link_objects_to_employment_short_ids(employment_collection)
          @entities.each do |id, unit_entity|
            if unit_entity.new_data
              unit_entity.old_object.employ_ids = employment_collection.short_ids_by_external_ids(unit_entity.new_data.employment_ids).presence
            end
          end
        end


        def link_objects_to_contact_short_ids(contact_collection)
          @entities.each do |id, unit_entity|
            if unit_entity.new_data
              unit_entity.old_object.contact_ids = contact_collection.short_ids_by_external_ids(unit_entity.new_data.contact_ids).presence
            end
          end
        end


        def reset_employments_link
          @entities.each do |id, unit_entity|
            unit_entity.new_data.employment_ids = [] unless unit_entity.new_data.employment_ids.nil?
          end
        end


        def delete_empty_units
          empty_units = find_empty_units
          empty_units.each do |empty_unit|
            delete_with_parent_items(empty_unit)
          end

        end


        def delete_with_parent_items(unit_entity)
          parent_unit = @entities[unit_entity.new_data.parent_external_id]
          remove_by_id(unit_entity.new_data.external_id)
          parent_unit.new_data.child_ids.delete(unit_entity.new_data.external_id)
          if parent_unit.new_data.child_ids.empty? && parent_unit.new_data.employment_ids.empty?
            delete_with_parent_items(parent_unit)
          end
        end


        def find_empty_units
          @entities.values.select do |unit_entity|
            !unit_entity.new_data.employment_ids.nil? &&
            unit_entity.new_data.employment_ids.empty? &&
            unit_entity.new_data.child_ids.empty?
          end
        end


        def select_company_management
          @entities.values.find do |unit_entity|
            unit_entity.new_data.title_includes?(COMPANY_MANAGEMENT_PREFIX)
          end
        end


        def change_company_managment(employment_collection)
          company_management_unit_entity = select_company_management
          company_management_employments = employment_collection.entities_by_ids(company_management_unit_entity.new_data.employment_ids)

          COMPANY_MANAGEMENT.each do |company_management|
            company_managment_employment = company_management_employments.find do |employment|
              employment.new_data.post_title.include?(company_management[:post_title])
            end
            has_changed = change_employment_unit(company_managment_employment, company_management[:unit_title])
            company_management_employments.delete(company_managment_employment) if has_changed
          end

          company_management_employments.each do |employment_entity|
            unit_title_substring = employment_entity.new_data.post_title.split(' ', 2)[1]
            change_employment_unit(employment_entity, unit_title_substring)
          end
        end


        def change_employment_unit(employment_entity, unit_title_substring)
          unit_entity = find_unit_by_partial_title(unit_title_substring)
          if unit_entity.present?
            employment_entity.new_data.unit_external_id = unit_entity.new_data.external_id
          end
        end


        def find_unit_by_partial_title(unit_title_substring)
          @entities.values.find { |unit_entity| unit_entity.new_data.title_includes?(unit_title_substring) }
        end


        def select_management_units
          @entities.values.select do |unit_entity|
            MANAGEMENT_PREFIX.any? { |regex| unit_entity.new_data.title_matches?(regex)}
          end
        end


        def change_management_unit(employment_collection)
          management_units = select_management_units

          management_units.each do |management_unit_entity|
            employments = employment_collection.entities_by_ids(management_unit_entity.new_data.employment_ids)
            employments.each do |employment|
              employment.new_data.unit_external_id = management_unit_entity.new_data.parent_external_id
            end
          end
        end


        def dump_employment_ids
          @entities.each do |id, entity|
            puts "#{entity.new_data.list_title}: [#{entity.new_data.employment_ids&.join(',')}] [#{entity.old_object.employ_ids&.join(',')}]"
          end
        end

        private


        def calc_unit_level(unit_entity)
          parent_external_id = unit_entity.new_data.parent_external_id
          unit_entity.new_data.level ||= parent_external_id.blank? ? 0 : calc_unit_level(@entities[parent_external_id]) + 1
        end

      end
    end
  end
end
