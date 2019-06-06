require 'utilities/import/collection'
require 'utilities/import/onpp/employment_entity'

module Utilities
  module Import
    module ONPP
      class EmploymentCollection

        include Utilities::Import::Collection


        self.entity_class = Utilities::Import::ONPP::EmploymentEntity
        self.object_class = ::Employment


        def import(doc, node_collection)
          doc.xpath('.//person').each do |person|
            unless present_in_black_list?(person['ID_M']) || node_collection.present_in_black_list?(person['ID_PODR'])
              new_data = Utilities::Import::ONPP::EmploymentData.new(person)
              add_new_data(new_data) if new_data.may_add?
            end
          end
        end


        def import_black_list(doc)
          doc.xpath('.//person').map do |person|
            add_black_list(person['ID'])
          end
        end


        def person_has_employment?(person_id)
          employments = @entities.values.select do |employment_entity|
            employment_entity.new_data.person_external_id == person_id
          end
          employments.empty? ? (false) : (true)
        end


        def assign_head_id(node_collection)
          each_fresh_entity do |entity|
            entity.assign_head_id(node_collection)
          end
        end


        def link_node_objects(node_collection)
          @entities.each do |id, entity|
            entity.link_node_objects(node_collection)
          end
        end


        def link_data_to_people(person_collection)
          @entities.each do |id, employment_entity|
            person_entity = person_collection[ employment_entity.new_data.person_external_id ]
            person_entity.new_data.add_employment_data(employment_entity.new_data)
          end
        end


        def link_data_to_nodes(node_collection)
          @entities.each do |id, employment_entity|
            node_entity = node_collection[ employment_entity.new_data.parent_node_external_id ]
            node_entity.new_data.add_child_employment_data(employment_entity.new_data)
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


        def link_objects_to_department(node_collection)
          @entities.each do |id, employment_entity|
            if employment_entity.new_data.present?
              unit_entity = node_collection[ employment_entity.new_data.department_unit_id ]
              if unit_entity.present? && unit_entity.new_data.type == 'dep'
                employment_entity.old_object.department = unit_entity.old_object
                employment_entity.old_object.department_short_id = unit_entity.old_object.short_id
              end
            end
          end
        end


        def get_department_node_ids
          @entities.map { |id, employment_entity| employment_entity.new_data.department_node_external_id }.uniq.compact
        end

      end
    end
  end
end
