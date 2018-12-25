module Utilities
  module Import
    module ONPP
      class Unit

        attr_accessor :external_id,
                      :long_title, :short_title, :list_title,
                      :parent_external_id,
                      :child_ids,
                      :employment_ids,
                      :contact_ids,
                      :path, :level


        def initialize(hash)
          @external_id        = hash[:external_id]
          @long_title         = hash[:long_title]
          @short_title        = hash[:short_title]
          @list_title         = hash[:list_title]
          @path               = hash[:path]
          @parent_external_id = hash[:parent_external_id]

          @child_ids      = []
        end


        def self.new_from_xml(source_data)
          external_id        = source_data['ID']
          long_title         = source_data['FULLNAME'].gsub(/\s{2,}/, ' ').strip.presence
          short_title        = source_data['NAME'].gsub(/\s{2,}/, ' ').strip.presence
          long_title = nil if long_title == short_title
          list_title         = short_title || long_title
          path               = source_data['HASH']
          parent_external_id = source_data['UP_ID']
          hash = {
            external_id:  external_id,
            long_title: long_title,
            short_title: short_title,
            list_title: list_title,
            path: path,
            parent_external_id: parent_external_id
          }

          Unit.new(hash)
        end


        def self.new_from_yml(source_data)
          external_id = source_data["id"].to_s
          title = source_data["title"]

          hash = {
            external_id:  external_id,
            short_title: title,
            list_title: title,
            path: nil,
            parent_external_id: nil
          }

          Unit.new(hash)
        end


        def attributes
          {
            external_id:    external_id,
            long_title:     long_title,
            short_title:    short_title,
            list_title:     list_title,
            level:          level,
          }
        end


        def title_matches?(pattern)
          long_title&.match(pattern) || short_title&.match(pattern)
        end


        def title_includes?(substring)
          long_title&.include?(substring) || short_title&.include?(substring)
        end

      end
    end
  end
end
