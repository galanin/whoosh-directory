module Utilities
  module Import
    module Tuner

      def load_tunes(tuning_file_path)
        begin
          @tunes = YAML.load_file tuning_file_path
        rescue Errno::ENOENT
          p "Missing tuning file. File path: #{tuning_file_path}"
          @tunes = {}
        end

        @head_posts = @tunes['heads']['auto']['posts'] rescue []
        @no_auto_heads_units = Set.new(@tunes['heads']['auto']['except_units'].map(&:presence).compact) rescue Set.new
        @head_exceptions = @tunes['heads']['exceptions'] rescue []

        @employment_replaces = @tunes['employment_replacement'] || []

        @pseudo_units = @tunes['pseudo_units'] || []

        @employee_to_node = @tunes['employee_to_node'] || []
        @move_nodes = @tunes['move_nodes'] || []

        @root_node_order = @tunes['root_node_order'] || []

        @organization_id = @tunes['node_type']['organization']
        @director_id = @tunes['node_type']['director']
        @vice_ids = @tunes['node_type']['vice']
        @manager_rules = @tunes['node_type']['manager']['rules']

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


      def assign_root_sort
        @root_node_order.each_with_index do |id, i|
          node = @nodes[id]
          if node
            node.new_data.root_sort = '%04d' % i
          end
        end
      end


      def set_nodes_type
        set_organization_type_to_node
        set_director_type_to_node
        set_vice_type_to_nodes
        find_and_set_manager_type_to_nodes
      end


      private


      def head?(post_title)
        @head_posts.any? { |re| re.is_a?(Regexp) ? re =~ post_title : post_title === re }
      end


      def set_organization_type_to_node
        node = @nodes[@organization_id]
        node.new_data.node_type = 'org' unless node.nil?
      end

      def set_director_type_to_node
        node = @nodes[@director_id]
        node.new_data.node_type = 'dir' unless node.nil?
      end


      def set_vice_type_to_nodes
        @nodes.each do |id, entity|
          entity_new_data = entity.new_data
          if entity_new_data.employment_external_id.present? && @vice_ids.include?(entity_new_data.employment_external_id)
            entity_new_data.node_type = 'vice'
          end
        end
      end


      def find_and_set_manager_type_to_nodes
        whitelist_managers_ids = find_whitelist_manager_nodes
        result_managers_ids = remove_blacklist_manager_nodes(whitelist_managers_ids)
        set_manager_type_to_nodes(result_managers_ids)
      end


      def find_whitelist_manager_nodes
        white_list_nodes_ids = []
        @nodes.each do |id, entity|
          entity_new_data = entity.new_data
          @manager_rules['whitelist'].each do |rule|
            if entity_new_data.title.downcase.include?(rule) && entity_new_data.employment_external_id.present?
              white_list_nodes_ids << id
              break
            end
          end
        end
        white_list_nodes_ids
      end


      def remove_blacklist_manager_nodes(manager_ids)
        blacklist_ids = []

        manager_ids.each do |id|
          title = @nodes[id].new_data.title.downcase

          @manager_rules['blacklist'].each do |rule|
            if title.include?(rule)
              blacklist_ids << id
            end
          end
        end

        manager_ids - blacklist_ids
      end


      def set_manager_type_to_nodes(manager_node_ids)
        manager_node_ids.each do |id|
          node = @nodes[id]
          node.new_data.node_type = 'mang' unless node.nil?
        end
      end


    end
  end
end
