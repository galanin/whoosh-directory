require 'utilities/import/collection'

module Utilities
  module Import
    module ONPP
      class EmploymentCollection

        include Utilities::Import::Collection


        def import(doc)
          doc.xpath('.//person').each do |person|
            new_data = Utilities::Import::ONPP::Employment.new(person)
            add_new_data(new_data)
          end
        end


        def link_data_to_people(person_collection)
          @entities.each do |id, employment_entity|
            person_entity = person_collection[ employment_entity.new_data.person_external_id ]
            person_entity.new_data.employment_ids << id
          end
        end


        def link_data_to_units(unit_collection)
          @entities.each do |id, employment_entity|
            unit_entity = unit_collection[ employment_entity.new_data.unit_external_id ]
            unit_entity.new_data.employment_ids << id
          end
        end


        def link_objects_to_people(person_collection)
          @entities.each do |id, employment_entity|
            if employment_entity.new_data.present?
              person_entity = person_collection[ employment_entity.new_data.person_external_id ]
              employment_entity.old_object.person = person_entity.old_object
              employment_entity.old_object.person_short_id = person_entity.old_object.short_id
            end
          end
        end


        def link_objects_to_units(unit_collection)
          @entities.each do |id, employment_entity|
            if employment_entity.new_data.present?
              unit_entity = unit_collection[ employment_entity.new_data.unit_external_id ]
              employment_entity.old_object.unit = unit_entity.old_object
              employment_entity.old_object.unit_short_id = unit_entity.old_object.short_id
            end
          end
        end

      end
    end
  end
end
