module Utilities
  module Import
    module ONPP
      class NodeEntity

        include Utilities::Import::Entity


        def assign_head_id(unit_collection)
          new_data.assign_head_id(unit_collection)
        end


        def link_node_objects(node_collection)
          old_object.link_parent(node_collection.object_by_external_id(new_data.parent_node_external_id))
          old_object.link_children(node_collection.objects_by_external_ids(new_data.child_node_external_ids))
        end


        def link_employment_objects(employment_collection)
          old_object.link_employment(employment_collection.object_by_external_id(new_data.employment_external_id))
          old_object.link_child_employments(employment_collection.objects_by_external_ids(new_data.child_employment_external_ids))
        end


        def link_contact_objects(contact_collection)
          old_object.link_child_contacts(contact_collection.objects_by_external_ids(new_data.child_contact_external_ids))
        end


        def link_unit_objects(unit_collection)
          old_object.link_unit(unit_collection.object_by_external_id(new_data.unit_external_id))
        end


        def inspect
          @new_data.inspect
        end

      end
    end
  end
end
