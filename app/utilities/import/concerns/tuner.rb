module Utilities
  module Import
    module Tuner

      def load_tunes(tuning_file_path)
        @tunes = YAML.load_file tuning_file_path rescue {}

        @head_posts = @tunes['heads']['auto']['posts'] rescue []
        @no_auto_heads_units = Set.new(@tunes['heads']['auto']['except_units'].map(&:presence).compact) rescue Set.new
        @head_exceptions = @tunes['heads']['exceptions'] rescue []

        @employment_replaces = @tunes['employment_replacement'] || []

        @pseudo_units = @tunes['pseudo_units'] || []

        @employee_to_node = @tunes['employee_to_node'] || []
        @move_nodes = @tunes['move_nodes'] || []
      end


      def set_head_flags
        return unless @head_posts.present?

        @employments.each_fresh_entity do |entity|
          data = entity.new_data
          unless data.parent_node_external_id.in?(@no_auto_heads_units)
            if head?(data.post_title)
              data.is_head = true
            end
          end
        end
      end


      def set_exception_head_ids
        @head_exceptions.each do |exception|
          @unit_entity = @units[exception['unit']]
          @employment_entity = @employments[exception['employee']]
          if @unit_entity && @employment_entity
            @unit_entity.new_data.head_external_id = exception['employee']
          end
        end
      end


      def replace_employments
        @employment_replaces.each do |data|
          employment_entity = @employments[data['employment']]
          if employment_entity &&
              employment_entity.new_data.post_title == data['from']['post_title'] &&
              employment_entity.new_data.parent_node_external_id == data['from']['unit']

            employment_entity.new_data.post_title = data['to']['post_title'] if data['to']['post_title'].present?
            employment_entity.new_data.parent_node_external_id = data['to']['unit'] if data['to']['unit'].present?
          end
        end
      end


      def replace_pseudo_units
        @pseudo_units.each do |data|
          node_entity = @nodes[data['unit']]
          employment_entity = @employments[data['employment']]
          if node_entity && employment_entity
            node_entity.new_data.unit_external_id       = nil
            node_entity.new_data.employment_external_id = employment_entity.new_data.external_id
            node_entity.new_data.title                  = employment_entity.new_data.post_title

            employment_entity.new_data.parent_node_external_id = nil
            employment_entity.new_data.node_external_id        = node_entity.new_data.external_id
            employment_entity.new_data.node_external_id        = node_entity.new_data.external_id
          end
        end
      end


      def convert_employee_to_node
        @employee_to_node.each do |data|
          employment_entity = @employments[data['employee']]
          if employment_entity
            new_data = Utilities::Import::ONPP::NodeData.new_from_employee(employment_entity.new_data, data)
            @nodes.add_new_data(new_data)
          end
        end
      end


      def move_nodes
        @move_nodes.each do |data|
          node_entity = @nodes[data['node']]
          if node_entity
            node_entity.new_data.parent_node_external_id = data['to_parent']
            node_entity.new_data.tree_sort = data['number']
          end
        end
      end


      private


      def head?(post_title)
        @head_posts.any? { |re| re.is_a?(Regexp) ? re =~ post_title : post_title === re }
      end

    end
  end
end
