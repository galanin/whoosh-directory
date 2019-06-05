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
          fresh_entities.each do |node_entity|
            node_entity.assign_head_id(unit_collection)
          end
        end


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


        def link_contact_objects(contact_collection)
          fresh_entities.each do |node_entity|
            node_entity.link_contact_objects(contact_collection)
          end
        end


        def link_unit_objects(unit_collection)
          fresh_entities.each do |node_entity|
            node_entity.link_unit_objects(unit_collection)
          end
        end


        COMPANY_MANAGEMENT_PREFIX = 'Руководство предприятия'
        RIGHT_NODE_FOR_POST       = [
          {
            post_title: 'Генеральный директор',
            node_title: 'Обнинское научно-производственное предприятие'
          },
          {
            post_title: 'Первый заместитель генерального директора',
            node_title: 'Блок первого заместителя генерального директора'
          }
        ]

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
            puts 'IMPORT CONTACT NODE'
            p new_data
            add_new_data(new_data)
            p @entities[new_data.external_id]
            puts
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


        def select_company_management
          @entities.values.find do |node_entity|
            node_entity.new_data.title_includes?(COMPANY_MANAGEMENT_PREFIX)
          end
        end


        def change_company_management(employment_collection)
          company_management_node_entity = select_company_management
          company_management_employments = employment_collection.entities_by_ids(company_management_node_entity.new_data.child_employment_external_ids)

          RIGHT_NODE_FOR_POST.each do |node_post_rule|
            employment_to_correct = company_management_employments.find do |employment|
              employment.new_data.post_title.include?(node_post_rule[:post_title])
            end
            has_changed = change_employment_node(employment_to_correct, node_post_rule[:node_title])
            company_management_employments.delete(employment_to_correct) if has_changed
          end

          company_management_employments.each do |employment_entity|
            node_title_substring = employment_entity.new_data.post_title.split(' ', 2)[1]
            change_employment_node(employment_entity, node_title_substring)
          end
        end


        def change_employment_node(employment_entity, node_title_substring)
          node_entity = find_node_by_partial_title(node_title_substring)
          if node_entity.present?
            employment_entity.new_data.parent_node_external_id = node_entity.new_data.external_id
          end
        end


        def find_node_by_partial_title(node_title_substring)
          @entities.values.find { |node_entity| node_entity.new_data.title_includes?(node_title_substring) }
        end


        def management_nodes
          @entities.values.select do |node_entity|
            MANAGEMENT_PREFIX.any? { |regex| node_entity.new_data.title_matches?(regex)}
          end
        end


        def change_management_node(employment_collection)
          management_nodes.each do |node_entity|
            employments = employment_collection.entities_by_ids(node_entity.new_data.child_employment_external_ids)
            employments.each do |employment|
              employment.new_data.parent_node_external_id = node_entity.new_data.parent_node_external_id
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
