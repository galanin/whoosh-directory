require 'utilities/import/collection'
require 'utilities/import/demo/node_entity'

module Utilities
  module Import
    module Demo
      class NodeCollection

        include Utilities::Import::Collection


        self.entity_class = Utilities::Import::Demo::NodeEntity
        self.object_class = ::Node


        def assign_lunch_to_employments(employment_collection)
          fresh_entities.each do |node_entity|
            node_entity.assign_lunch_to_employments(employment_collection)
          end
        end


        def assign_head_id(unit_collection)
          each_fresh_entity do |node_entity|
            node_entity.assign_head_id(unit_collection)
          end
        end


        def link_node_objects
          each_fresh_entity do |node_entity|
            node_entity.link_node_objects(self)
          end
        end


        def link_employment_objects(employment_collection)
          each_fresh_entity do |node_entity|
            node_entity.link_employment_objects(employment_collection)
          end
        end


        def link_unit_objects(unit_collection)
          each_fresh_entity do |node_entity|
            node_entity.link_unit_objects(unit_collection)
          end
        end

      end
    end
  end
end
