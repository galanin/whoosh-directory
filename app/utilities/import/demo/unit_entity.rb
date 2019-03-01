module Utilities
  module Import
    module Demo
      class UnitEntity

        include Utilities::Import::Entity


        def link_node_objects(node_collection)
          old_object.node = node_collection.object_by_external_id(new_data.node_external_id)
          old_object.node_short_id = old_object.node&.short_id
        end

      end
    end
  end
end
