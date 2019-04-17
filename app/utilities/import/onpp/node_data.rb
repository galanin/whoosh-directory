module Utilities
  module Import
    module ONPP
      class NodeData
        include Utilities::Import::Data

        COLLAPSED_NODE_TYPES = %w(section dep)

        attr_reader :short_title, :long_title, :alpha_sort

        attr_reader :title
        attr_reader :tree_sort
        attr_accessor :node_type
        attr_accessor :unit_external_id, :employment_external_id
        attr_accessor :parent_node_external_id
        attr_reader :child_node_external_ids
        attr_reader :child_employment_external_ids
        attr_reader :child_contact_external_ids


        def initialize(source_data)
          @external_id        = source_data[:id]
          @unit_external_id   = source_data[:id]
          @long_title         = source_data[:long_title]
          @short_title        = source_data[:short_title]

          @title              = short_title || long_title
          @alpha_sort         = @title
          @tree_sort          = source_data[:tree_sort]
          @parent_node_external_id = source_data[:parent_id]

          @child_node_external_ids = []
          @child_employment_external_ids = []
          @child_contact_external_ids = []
        end


        def self.new_from_xml(source_data)
           long_title         = normalize_any_title(source_data['FULLNAME']).gsub(/\s{2,}/, ' ').strip.presence
           short_title        = normalize_any_title(source_data['NAME']).gsub(/\s{2,}/, ' ').strip.presence
           short_title        = nil if banned_short_title?(short_title)
           long_title         = nil if long_title == short_title

           if short_title.nil? && long_title.present?
             short_title      = long_title
             long_title       = nil
           end

           new(
             id:        source_data['ID'],
             long_title:         long_title,
             short_title:        short_title,
             tree_sort:               source_data['HASH'],
             parent_id: source_data['UP_ID'],
           )
        end


        def self.new_from_yml(source_data)
          new(
            id:          source_data['id'].to_s,
            short_title: source_data['title'],
            tree_sort:   nil,
          )
        end


        def attributes
          {
            external_id:      external_id,
            title:            title,
            node_type:        node_type,
            default_expanded: !node_type.in?(COLLAPSED_NODE_TYPES)
          }
        end


        def unit_data
          {
            id:          external_id,
            node_id:     external_id,
            long_title:  long_title,
            short_title: short_title,
            alpha_sort:  alpha_sort,
          }
        end


        def title_matches?(pattern)
          @long_title&.match(pattern) || @short_title&.match(pattern)
        end


        def title_includes?(substring)
          @long_title&.include?(substring) || @short_title&.include?(substring)
        end


        def add_node_employment_data(employment_data)
          @employment_external_id = employment_data.external_id
          employment_data.node_external_id = @external_id
        end


        def add_child_node_data(child_node_data)
          # m = 'BROKEN ID HIERARCHY' unless proper_child_id?(child_node_data)
          # puts " add #{ child_node_data.external_id } to #{ external_id } #{ m }"
          @child_node_external_ids << child_node_data.external_id
          # child_node_data.parent_node_external_id = @external_id
        end


        def add_child_employment_data(employment_data)
          @child_employment_external_ids << employment_data.external_id
          employment_data.parent_node_external_id = @external_id
        end


        def add_child_contact_data(contact_data)
          @child_contact_external_ids << contact_data.external_id
          contact_data.parent_node_external_id = @external_id
        end


        def proper_child_id?(child_node_data)
          external_id.size + 1 == child_node_data.external_id.size and
            child_node_data.external_id.start_with?(external_id)
        end


        def reset_employments
          @child_employment_external_ids = []
        end


        def reset_children
          @child_node_external_ids = []
        end


        def sort_children!(node_collection)
          @child_node_external_ids.sort_by! { |child_id| node_collection[child_id].new_data.tree_sort }
        end


        def sort_employments!(employment_collection)
          @child_employment_external_ids.sort_by! { |employment_id| employment_collection[employment_id].new_data.employment_priority }
        end


        def empty?
          @child_employment_external_ids.empty? && @child_node_external_ids.empty? && @child_contact_external_ids.empty?
        end


        def set_head(employment_collection, unit_collection)
          if @unit_external_id.present?
            unit_entity = unit_collection[@unit_external_id]
            if unit_entity.present?
              unit_entity.new_data.head_external_id = head_employment_external_id(employment_collection)
            end
          end
        end


        def head_employment_external_id(employment_collection)
          @child_employment_external_ids.find do |employment_id|
            employment = employment_collection[employment_id]
            employment.new_data.is_head
          end
        end


        def inspect
          "NodeData #{ @external_id } <#{ child_node_external_ids.join(', ') }> '#{ title }'"
        end


        private


        def self.normalize_any_title(title)
          new_title = title.upcase_first
          new_title.gsub!(/(\s+)"(\p{Word})/, '\1«\2')
          new_title.gsub!(/(\p{Word})"([\s,\.\-$])/, '\1»\2')
          new_title.gsub!(/"$/, '»')

          new_title.gsub!(/(\p{Lu}\.)\s*(\p{Lu}\.)\s*(\p{Lu})/, '\1 \2 \3')
          new_title
        end


        BANNED_TITLE_MATCHES = [
          /\p{Ll}\.\s*\p{Ll}/,
          /-\p{Ll}\p{Ll}[\s$]/,
        ]

        def self.banned_short_title?(short_title)
          BANNED_TITLE_MATCHES.any? { |match| short_title =~ match }
        end

      end
    end
  end
end
