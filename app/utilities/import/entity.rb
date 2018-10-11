module Utilities
  module Import
    class Entity

      attr_accessor :old_object, :new_data

      def initialize(object_class)
        @object_class = object_class
      end


      def new?
        new_data && !old_object
      end


      def stale?
        !new_data && old_object
      end


      def build_new_object
        self.old_object = @object_class.new(new_data.attributes)
      end


      def drop_stale_object
        old_object.set(destroyed_at: Time.now)
      end


      def flush_to_db
        old_object.update_attributes!(new_data.attributes)
      end

    end
  end
end
