module Utilities
  module Import
    module ONPP
      class Unit

        attr_accessor :external_id,
                      :long_title, :short_title, :list_title,
                      :parent_external_id,
                      :child_ids,
                      :employment_ids,
                      :path, :level


        def initialize(source_data)
          @external_id        = source_data['ID']
          @long_title         = source_data['FULLNAME'].gsub(/\s{2,}/, ' ').strip
          @short_title        = source_data['NAME'].gsub(/\s{2,}/, ' ').strip
          @list_title         = @long_title.length > 80 ? (@short_title.presence || @long_title) : (@long_title.presence || @short_title)
          @path               = source_data['HASH']
          @parent_external_id = source_data['UP_ID']

          @child_ids      = []
          @employment_ids = []
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

      end
    end
  end
end
