require 'utilities/import/collection'
require 'utilities/import/demo/employment_entity_set'

module Utilities
  module Import
    module Demo
      class EmploymentCollection

        include Utilities::Import::Collection


        self.entity_class = Utilities::Import::Demo::EmploymentEntitySet
        self.object_class = ::Employment


        def link_node_objects(node_collection)
          fresh_entities.each do |entity|
            entity.link_node_objects(node_collection)
          end
        end


        def objects_by_external_id(external_id)
          @entities[external_id]&.old_objects
        end


        def objects_by_external_ids(external_ids)
          external_ids&.map { |id| objects_by_external_id(id) }.compact.flatten
        end


        private

      end
    end
  end
end
