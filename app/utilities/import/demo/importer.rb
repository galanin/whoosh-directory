require 'yaml'
require 'utilities/import/demo/unit_collection'
require 'utilities/import/demo/employment_collection'
require 'faker'

module Utilities
  module Import
    module Demo
      class Importer

        def initialize
          @employments = Utilities::Import::Demo::EmploymentCollection.new
          @units       = Utilities::Import::Demo::UnitCollection.new
          @nodes       = Utilities::Import::Demo::NodeCollection.new
          @root_node   = nil
        end


        def import(language:)
          Faker::Config.locale = language.to_sym

          demo_yaml = YAML.load_file ENV['STAFF_DEMO_FILE_PATH']
          @root_node = parse_yaml_unit nil, demo_yaml
          @root_node.assign_lunch_time_recursively(@nodes)
          @nodes.assign_lunch_to_employments(@employments)

          @employments.fetch_from_db
          @units.fetch_from_db
          @nodes.fetch_from_db

          @employments.drop_stale_objects
          @units.drop_stale_objects
          @nodes.drop_stale_objects

          @employments.build_new_objects
          @units.build_new_objects
          @nodes.build_new_objects

          @employments.assign_phone_numbers

          # @employments.import_photos

          @employments.assign_head_id(@nodes)
          @nodes.assign_head_id(@units)

          # link the objects using external ids
          @employments.link_node_objects(@nodes)
          @units.link_node_objects(@nodes)
          @units.link_employment_objects(@employments)
          @nodes.link_node_objects
          @nodes.link_employment_objects(@employments)
          @nodes.link_unit_objects(@units)

          @employments.flush_to_db
          @units.flush_to_db
          @nodes.flush_to_db
        end


        def parse_yaml_employee(parent_node_data, yaml_node)
          employment_template_data = Utilities::Import::Demo::EmploymentTemplateData.new(yaml_node)
          @employments.add_new_data(employment_template_data)

          if yaml_node['employees'].present? || yaml_node['units'].present?
            node_data = Utilities::Import::Demo::NodeData.new(employment_template_data, yaml_node)
            @nodes.add_new_data(node_data)

            parent_node_data.add_child_node_data(node_data) if parent_node_data.present?
            node_data.add_node_employment_data(employment_template_data)

            # puts "[#{ parent_node_data&.external_id }] #{ node_data.external_id } '#{ node_data.title }'"

            parse_yaml_descendants(node_data, yaml_node)
          else
            parent_node_data.add_child_employment_data(employment_template_data)
            # puts "[#{ parent_node_data&.external_id }] #{ employment_template_data.external_id } {#{ employment_template_data.post_title }}"
          end

          node_data
        end


        def parse_yaml_unit(parent_node_data, yaml_node)
          unit_data = Utilities::Import::Demo::UnitData.new(yaml_node)
          @units.add_new_data(unit_data)

          node_data = Utilities::Import::Demo::NodeData.new(unit_data, yaml_node)
          @nodes.add_new_data(node_data)

          parent_node_data.add_child_node_data(node_data) if parent_node_data.present?
          node_data.add_node_unit_data(unit_data)

          # puts "[#{ parent_node_data&.external_id }] #{ node_data.external_id } '#{ node_data.title }'"

          parse_yaml_descendants(node_data, yaml_node)

          node_data
        end


        def parse_yaml_descendants(parent_node_data, yaml_node)
          if yaml_node['employees'].present?
            yaml_node['employees'].each do |yaml_child_node|
              parse_yaml_employee(parent_node_data, yaml_child_node)
            end
          end

          if yaml_node['units'].present?
            yaml_node['units'].each do |yaml_child_node|
              parse_yaml_unit(parent_node_data, yaml_child_node)
            end
          end
        end

      end
    end
  end
end
