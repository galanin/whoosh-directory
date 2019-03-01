module Utilities
  module Import
    module Demo
      class NodeEntity

        include Utilities::Import::Entity


        def link_node_objects(node_collection)
          old_object.parent          = node_collection.object_by_external_id(new_data.parent_node_external_id)
          old_object.parent_short_id = old_object.parent&.short_id

          children = node_collection.objects_by_external_ids(new_data.child_node_external_ids)
          old_object.children        = children
          old_object.child_short_ids = children.map(&:short_id)
        end


        def link_employment_objects(employment_collection)
          old_object.employment          = employment_collection.objects_by_external_id(new_data.employment_external_id)&.first
          old_object.employment_short_id = old_object.employment&.short_id

          employments = employment_collection.objects_by_external_ids(new_data.child_employment_external_ids)
          old_object.child_employments = employments
          old_object.employ_ids        = employments.map(&:short_id)
        end


        def link_unit_objects(unit_collection)
          old_object.unit          = unit_collection.object_by_external_id(new_data.unit_external_id)
          old_object.unit_short_id = old_object.unit&.short_id
        end

      end
    end
  end
end
