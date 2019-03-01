module Utilities
  module Import
    module Entity
      extend ActiveSupport::Concern

      included do
        attr_reader :old_object, :new_data

        def initialize(object_class)
          @object_class       = object_class
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
          @new_data.object = @old_object if @new_data.present?
        end


        def build_new_object
          @old_object = @object_class.build_new_object(new_data)
          @new_data.object = @old_object
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
end
