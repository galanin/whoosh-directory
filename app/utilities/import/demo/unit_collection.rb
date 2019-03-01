require 'utilities/import/collection'
require 'utilities/import/demo/unit_entity'

module Utilities
  module Import
    module Demo
      class UnitCollection

        include Utilities::Import::Collection


        self.entity_class = Utilities::Import::Demo::UnitEntity
        self.object_class = ::Unit


        def link_node_objects(node_collection)
          fresh_entities.each do |entity|
            entity.link_node_objects(node_collection)
          end
        end

      end
    end
  end
end
