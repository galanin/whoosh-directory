require 'utilities/import/collection'

module Utilities
  module Import
    module Demo
      class NodeCollection

        include Utilities::Import::Collection


        self.entity_class = Utilities::Import::Demo::NodeEntity
        self.object_class = ::Node


        def link_node_objects
          fresh_entities.each do |node_entity|
            node_entity.link_node_objects(self)
          end
        end


        def link_employment_objects(employment_collection)
          fresh_entities.each do |node_entity|
            node_entity.link_employment_objects(employment_collection)
          end
        end


        def link_unit_objects(unit_collection)
          fresh_entities.each do |node_entity|
            node_entity.link_unit_objects(unit_collection)
          end
        end

      end
    end
  end
end
