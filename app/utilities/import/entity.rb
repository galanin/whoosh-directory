module Utilities
  module Import
    class Entity

      attr_accessor :old_object, :new_data

      def initialize(object_class)
        @object_class = object_class
        @duplicated_objects = []
      end


      def new?
        new_data && !old_object
      end


      def stale?
        !new_data && old_object
      end


      def add_new_data(new_data)
        @new_data = new_data
      end


      def add_old_object(object)
        if @old_object.present?
          @old_object.drop
          @duplicated_objects << @old_object
        end
        @old_object = object
      end


      def build_new_object
        @old_object = @object_class.build_new_object(new_data)
      end


      def drop_stale_object
        old_object.drop
      end


      def flush_to_db
        old_object.flush_to_db(new_data)
      end

    end
  end
end
