require 'utilities/import/collection'
require 'utilities/import/onpp/node_entity'

module Utilities
  module Import
    module ONPP
      class NodeCollection

        include Utilities::Import::Collection


        self.entity_class = Utilities::Import::ONPP::NodeEntity
        self.object_class = ::Node


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


        def link_contact_objects(contact_collection)
          each_fresh_entity do |node_entity|
            node_entity.link_contact_objects(contact_collection)
          end
        end


        def link_unit_objects(unit_collection)
          each_fresh_entity do |node_entity|
            node_entity.link_unit_objects(unit_collection)
          end
        end


        MANAGEMENT_PREFIX = [/^Руководство/, /^Рук\./]

        def import_from_xml(doc)
          doc.xpath('.//organization').each do |org|
            unless present_in_black_list?(org['ID'])
              new_data = Utilities::Import::ONPP::NodeData.new_from_xml(org)
              add_new_data(new_data)
            end
          end
        end


        def import_from_yaml(yaml_doc)
          yaml_doc.each do |org|
            new_data = Utilities::Import::ONPP::NodeData.new_from_yml(org)
            add_new_data(new_data)
          end
        end


        def import_black_list(doc)
          doc.xpath('.//organization').map do |org|
            add_black_list(org['ID'])
          end
        end


        def reset_structure
          @entities.each do |id, node_entity|
            node_entity.new_data.reset_children
          end
        end


        def build_structure
          @entities.each do |id, node_entity|
            parent = @entities[node_entity.new_data.parent_node_external_id]
            if parent.present?
              parent.new_data.add_child_node_data(node_entity.new_data)
            end
          end
        end


        def sort_child_nodes
          @entities.each do |id, node_entity|
            node_entity.new_data.sort_children!(self)
          end
        end


        def sort_employments(employment_collection)
          @entities.each do |id, node_entity|
            node_entity.new_data.sort_employments!(employment_collection)
          end
        end


        def set_heads(employment_collection, unit_collection)
          @entities.each do |id, node_entity|
            node_entity.new_data.set_head(employment_collection, unit_collection)
          end
        end


        def reset_employments_link
          @entities.each do |id, node_entity|
            node_entity.new_data.reset_employments
          end
        end


        def delete_empty_nodes
          empty_nodes.each do |empty_node|
            delete_with_empty_parents(empty_node)
          end
        end


        def delete_with_empty_parents(node_entity)
          remove_by_id(node_entity.new_data.external_id)

          parent_node = @entities[node_entity.new_data.parent_node_external_id]
          if parent_node.present?
            # parent_node.new_data.child_ids.delete(node_entity.new_data.external_id)
            if parent_node.new_data.empty?
              delete_with_empty_parents(parent_node)
            end
          end
        end


        def empty_nodes
          @entities.values.select do |node_entity|
            node_entity.new_data.empty?
          end
        end


        def management_nodes
          @entities.select do |id, node_entity|
            MANAGEMENT_PREFIX.any? { |regex| node_entity.new_data.title_matches?(regex) }
          end.to_h
        end


        def change_management_node(employment_collection)
          m_nodes = management_nodes
          employment_collection.each do |id, employment_entity|
            node_entity = m_nodes[employment_entity.new_data.parent_node_external_id]
            if node_entity
              employment_entity.new_data.parent_node_external_id = node_entity.new_data.parent_node_external_id
              employment_entity.new_data.department_node_external_id = node_entity.new_data.parent_node_external_id
            end
          end
        end


        def dump_employment_ids
          @entities.each do |id, entity|
            puts "#{entity.new_data.list_title}: [#{entity.new_data.child_employment_external_ids.join(',')}] [#{entity.old_object.employ_ids&.join(',')}]"
          end
        end


        def get_structure_unit(employment_collection)
          employment_collection.get_department_node_ids.each do |node_id|
            @entities[node_id].new_data.node_type = 'dep'
          end
        end

      end
    end
  end
end
