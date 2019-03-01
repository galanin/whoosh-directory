module Utilities
  module Import
    module Data
      extend ActiveSupport::Concern

      included do

        attr_reader :external_id
        attr_accessor :object

      end

    end
  end
end
