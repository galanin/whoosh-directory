module Utilities
  module Import
    module Demo
      class EmploymentTemplateData
        include Utilities::Import::Data

        attr_reader   :post_title,
                      :post_type,
                      :is_manager,
                      :is_head,
                      :building, :office,
                      :count
        attr_accessor :lunch
        attr_accessor :node_external_id
        attr_accessor :parent_node_external_id


        def initialize(hash)
          unless hash.has_key? 'id'
            puts "Employment's ID is missing"
            puts "#{ hash['post_title'] } @ #{ hash['building'] }:#{ hash['office'] }"
          end
          @external_id = hash['id'].to_s
          @post_title  = hash['post_title'].presence || '-'
          @post_type   = hash['post_type']
          @is_manager  = @post_type == 'manager'
          @is_head     = hash['is_head']
          @building    = hash['building']
          @office      = hash['office']
          @count       = hash['count'] || 1
        end


        def attributes
          {
            external_id: external_id,
            post_title:  post_title,
            post_code:   post_type,
            is_manager:  is_manager,
            is_head:     is_head,
            building:    building,
          }
        end


        def assign_head_id(node_collection)
          if @parent_node_external_id.present? && @is_head
            parent_node_entity = node_collection[@parent_node_external_id]
            if parent_node_entity.present?
              parent_node_entity.new_data.head_external_id = @external_id
            end
          end
        end


        def link_node_data(node_data)
          @node_external_id = node_data.external_id
          node_data.employment_external_id = @external_id
        end


        def inspect
          "EmploymentData '#{post_title}' [#{count}]\n node: #{ node_external_id } parent: #{ parent_node_external_id }"
        end

      end
    end
  end
end
