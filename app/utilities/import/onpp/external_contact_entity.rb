module Utilities
  module Import
    module ONPP
      class ExternalContactEntity

        include Utilities::Import::Entity


        def link_node_objects(node_collection)
          old_object.link_parent_node(node_collection.object_by_external_id(new_data.parent_node_external_id))
        end


        def inspect
          @new_data.inspect
        end

      end
    end
  end
end
