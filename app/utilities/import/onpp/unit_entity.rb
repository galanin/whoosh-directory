module Utilities
  module Import
    module ONPP
      class UnitEntity

        include Utilities::Import::Entity


        def link_node_objects(node_collection)
          old_object.link_node(node_collection.object_by_external_id(new_data.node_external_id))
        end


        def link_employment_objects(employment_collection)
          old_object.link_head(employment_collection.object_by_external_id(new_data.head_external_id))
        end

      end
    end
  end
end
