module Utilities
  module Import
    module ONPP
      class PersonEntity

        include Utilities::Import::Entity


        def inspect
          @new_data.inspect
        end

      end
    end
  end
end
