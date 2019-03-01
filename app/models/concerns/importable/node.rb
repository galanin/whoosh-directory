module Importable
  module Node
    extend ActiveSupport::Concern

    included do

      def link_units(unit)
        self.unit = unit
        self.unit_short_id = unit&.short_id
      end

    end
  end
end
