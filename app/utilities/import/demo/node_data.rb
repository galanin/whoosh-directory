module Utilities
  module Import
    module Demo
      class NodeData
        include Utilities::Import::Data

        COLLAPSED_NODE_TYPES = %w(section dep)

        attr_reader :title, :node_type
        attr_accessor :unit_external_id, :employment_external_id
        attr_accessor :parent_node_external_id, :head_external_id
        attr_reader :child_node_external_ids
        attr_reader :child_employment_external_ids


        def initialize(encapsulated_data, hash)
          @external_id = encapsulated_data.external_id
          @node_type   = hash['node_type']

          case encapsulated_data
          when Utilities::Import::Demo::UnitData
            @title   = encapsulated_data.short_title || encapsulated_data.long_title

          when Utilities::Import::Demo::EmploymentTemplateData
            @title   = encapsulated_data.post_title
          end

          @child_node_external_ids = []
          @child_employment_external_ids = []
        end


        def attributes
          {
            external_id:      external_id,
            title:            title,
            node_type:        node_type,
            default_expanded: !node_type.in?(COLLAPSED_NODE_TYPES)
          }
        end


        def add_node_employment_data(employment_data)
          @employment_external_id = employment_data.external_id
          employment_data.node_external_id = @external_id
        end


        def add_node_unit_data(unit_data)
          @unit_external_id = unit_data.external_id
          unit_data.node_external_id = @external_id
        end


        def add_child_node_data(child_node_data)
          # m = 'BROKEN ID HIERARCHY' unless proper_child_id?(child_node_data)
          # puts " add #{ child_node_data.external_id } to #{ external_id } #{ m }"
          @child_node_external_ids << child_node_data.external_id
          child_node_data.parent_node_external_id = @external_id
        end


        def add_child_employment_data(employment_node_data)
          @child_employment_external_ids << employment_node_data.external_id
          employment_node_data.parent_node_external_id = @external_id
        end


        def proper_child_id?(child_node_data)
          external_id.size + 1 == child_node_data.external_id.size and
            child_node_data.external_id.start_with?(external_id)
        end


        def assign_head_id(unit_collection)
          if @unit_external_id.present?
            unit_entity = unit_collection[@unit_external_id]
            if unit_entity.present?
              unit_entity.new_data.head_external_id = @head_external_id
            end
          end
        end


        def inspect
          "NodeData #{ @variant } #{ @external_id } <#{ child_node_external_ids.join(', ') }> '#{ title }'"
        end

      end
    end
  end
end
