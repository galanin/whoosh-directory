module Utilities
  module Import
    module Demo
      class NodeData
        include Utilities::Import::Data

        UNIT = 'unit'
        EMPLOYMENT = 'employment'

        attr_reader :variant, :title, :type
        attr_accessor :unit_external_id, :employment_external_id
        attr_accessor :parent_node_external_id
        attr_reader :child_node_external_ids
        attr_reader :child_employment_external_ids


        def initialize(encapsulated_data, hash)
          @external_id = encapsulated_data.external_id
          @type        = hash['type']

          case encapsulated_data
          when Utilities::Import::Demo::UnitData
            @variant = UNIT
            @title   = encapsulated_data.short_title || encapsulated_data.long_title

          when Utilities::Import::Demo::EmploymentTemplateData
            @variant = EMPLOYMENT
            @title   = encapsulated_data.post_title
          end

          @child_node_external_ids = []
          @child_employment_external_ids = []
        end


        def unit?
          variant == UNIT
        end


        def employment?
          variant == EMPLOYMENT
        end


        def attributes
          {
            external_id:         external_id,
            title:               title,
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
          @child_node_external_ids << child_node_data.external_id
          child_node_data.parent_node_external_id = @external_id
        end


        def add_child_employment_data(employment_node_data)
          @child_employment_external_ids << employment_node_data.external_id
          employment_node_data.parent_node_external_id = @external_id
        end



        def inspect
          "NodeData #{ @variant } '#{ title }'>"
        end

      end
    end
  end
end
