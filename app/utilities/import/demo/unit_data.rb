module Utilities
  module Import
    module Demo
      class UnitData
        include Utilities::Import::Data

        attr_reader   :long_title, :short_title, :alpha_sort
        attr_accessor :node_external_id, :head_external_id


        def initialize(hash)
          unless hash.has_key? 'id'
            puts "Unit's ID is missing"
            puts hash['long_title']
          end
          @external_id = hash['id'].to_s
          @long_title  = hash['long_title']
          @short_title = hash['short_title']
          @alpha_sort  = @short_title || @long_title
        end


        def attributes
          {
            external_id: external_id,
            long_title:  long_title,
            short_title: short_title,
            alpha_sort:  alpha_sort,
          }
        end


        def inspect
          "UnitData '#{ long_title }'>"
        end

      end
    end
  end
end
