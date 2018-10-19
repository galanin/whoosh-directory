require 'utilities/import/collection'

module Utilities
  module Import
    module ONPP
      class UnitCollection

        include Utilities::Import::Collection

        COMPANY_MANAGMENTS_PREFIX = 'Руководство предприятия'
        COMPANY_MANAGMENT = [
          {
            post_title: 'Генеральный директор',
            unit_title: 'Акционерное общество "Обнинское научно-производственное предприятие "Технология" им. А.Г. Ромашина"'
          },
          {
            post_title: 'Первый заместитель генерального директора',
            unit_title: 'Блок первого заместителя генерального директора'
          }
        ]

        MANAGMENT_PREFIX = [/^Руководство/,/^Рук\./]

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


        def import(doc)
          doc.xpath('.//organization').each do |org|
            new_data = Utilities::Import::ONPP::Unit.new(org)
            add_new_data(new_data)
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
          employment_with_priority = {}

          POST_PRIORITY.find do |post|
            if employment_post =~ post[:post]
              employment_with_priority[:epmloyment_id] = employment_unit_entity.new_data.external_id
              employment_with_priority[:priority] = post[:priority]
            end
          end

          employment_with_priority
        end



        def sort_employments(employment_collection)
          @entities.each do |id, unit_entity|
            employmet_ids = unit_entity.new_data.employment_ids
            employments = employment_collection.entites_by_ids(employmet_ids)

            employments_with_priority = employments.map do |employment_unit|
              set_priority(employment_unit)
            end

            employments_with_priority.sort_by!{ |employment_with_priority| employment_with_priority[:priority] }
            unit_entity.new_data.employment_ids = employments_with_priority.map { |employment| employment[:epmloyment_id] }
          end
        end


        def calc_levels
          @entities.each do |id, unit_entity|
            calc_unit_level(unit_entity)
          end
        end


        def link_objects_to_children_short_ids
          @entities.each do |id, unit_entity|
            unit_entity.old_object.child_ids = short_ids_by_external_ids(unit_entity.new_data.child_ids)
          end
        end


        def link_objects_to_employment_short_ids(employment_collection)
          @entities.each do |id, unit_entity|
            unit_entity.old_object.employ_ids = employment_collection.short_ids_by_external_ids(unit_entity.new_data.employment_ids)
          end
        end


        def reset_employments_link
          @entities.each do |id, unit_entity|
            unit_entity.new_data.employment_ids = []
          end
        end


        def delete_empty_units
          empty_units = @entities.values.select do |unit_entity|
            unit_entity.new_data.employment_ids.empty? &&
            unit_entity.new_data.child_ids.empty?
          end
          empty_units.each {|empty_unit| remove_by_id(empty_unit.new_data.external_id) }
        end


        def select_company_managment
          @entities.values.find do |unit_entity|
            unit_entity.new_data.long_title.include?(COMPANY_MANAGMENTS_PREFIX)
          end
        end


        def change_company_managment(employment_collection)
          company_managments_unit_entity = select_company_managment
          company_managment_employments = employment_collection.entites_by_ids(company_managments_unit_entity.new_data.employment_ids)

          COMPANY_MANAGMENT.each do |company_managment|
            company_managment_employment = company_managment_employments.find do |employment|
              employment.new_data.post_title.include?(company_managment[:post_title])
            end
            result = change_employment_unit(company_managment_employment, company_managment[:unit_title])
            company_managment_employments.delete(company_managment_employment) if result
          end

          company_managment_employments.each do |employment_entity|
            unit_title_substring = employment_entity.new_data.post_title.split(' ', 2)[1]
            change_employment_unit(employment_entity, unit_title_substring)
          end
        end


        def change_employment_unit(employment_entity, unit_title_substring)
          unit_entity = find_unit_by_partial_title(unit_title_substring)
          unit_entity.nil? ? (false) : (employment_entity.new_data.unit_external_id = unit_entity.new_data.external_id)
        end


        def find_unit_by_partial_title(title_substring)
          @entities.values.find{ |unit_entity| unit_entity.new_data.long_title.include?(title_substring)}
        end


        def select_management_unit
          @entities.values.select do |unit_entity|
            MANAGMENT_PREFIX.any? { |regex| unit_entity.new_data.long_title =~ (Regexp.new regex)}
          end
        end


        def change_management_unit(employment_collection)
          management_units = select_management_unit

          management_units.each do |management_unit_entity|
            employments = employment_collection.entites_by_ids(management_unit_entity.new_data.employment_ids)
            employments.each do |employment|
              employment.new_data.unit_external_id = management_unit_entity.new_data.parent_external_id
            end
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
