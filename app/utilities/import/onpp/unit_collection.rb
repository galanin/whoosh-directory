require 'utilities/import/collection'
require 'utilities/import/onpp/unit_entity'

module Utilities
  module Import
    module ONPP
      class UnitCollection

        include Utilities::Import::Collection

        self.entity_class = Utilities::Import::ONPP::UnitEntity
        self.object_class = ::Unit


        def import_from_nodes(node_collection)
          node_collection.each do |id, node_entity|
            new_data = new_data = Utilities::Import::ONPP::UnitData.new(node_entity.new_data.unit_data)
            add_new_data(new_data)
          end
        end


        def link_node_objects(node_collection)
          fresh_entities.each do |entity|
            entity.link_node_objects(node_collection)
          end
        end


        def link_employment_objects(employment_collection)
          fresh_entities.each do |entity|
            entity.link_employment_objects(employment_collection)
          end
        end

      end
    end
  end
end
