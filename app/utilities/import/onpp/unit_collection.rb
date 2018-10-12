require 'utilities/import/collection'

module Utilities
  module Import
    module ONPP
      class UnitCollection

        include Utilities::Import::Collection


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


        def sort_employments
          # TODO implement
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


        private


        def calc_unit_level(unit_entity)
          parent_external_id = unit_entity.new_data.parent_external_id
          unit_entity.new_data.level ||= parent_external_id.blank? ? 0 : calc_unit_level(@entities[parent_external_id]) + 1
        end

      end
    end
  end
end
