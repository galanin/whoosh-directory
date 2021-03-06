module Utilities
  module Import
    module Demo
      module EntitySet
        extend ActiveSupport::Concern

        included do

          attr_accessor :old_objects, :new_data


          def initialize(object_class)
            @object_class = object_class
            @old_objects  = []
          end


          def new?
            new_data.present? && new_data.count > old_objects.count
          end


          def stale?
            !new_data || new_data.present? && new_data.count < old_objects.count
          end


          def add_new_data(new_data)
            @new_data = new_data
          end


          def add_old_object(old_object)
            @old_objects << old_object
          end


          def build_new_object
            generate_missing
            drop_excessive
          end


          def generate_missing_objects
            missing_count.times do
              new_object = build_new_single_object(new_data)
              yield new_object
              add_old_object(new_object)
            end
          end


          def drop_excessive_objects
            excess_objects.each do |object|
              yield object
              object.drop
            end
          end


          def update_existing_objects
            existing_objects.each do |object|
              yield object
            end
          end


          def drop_stale_object
            drop_excessive
          end


          def inspect
            "EntitySet <#{ @new_data.inspect }>\n#{ @old_objects.map { |o| ' ' + o.inspect }.join("\n") }"
          end


          private


          def build_new_single_object(data)
            @object_class.build_new_object(data)
          end


          def need_count
            new_data&.count || 0
          end


          def present_count
            old_objects.count
          end


          def missing_count
            need_count > present_count ? need_count - present_count : 0
          end


          def excess_count
            present_count > need_count ? present_count - need_count : 0
          end


          def existing_count
            [present_count, need_count].min
          end


          def proper_objects
            if present_count > need_count
              @old_objects.slice(0, need_count)
            else
              @old_objects
            end
          end


          def excess_objects
            if present_count > need_count
              @old_objects.slice(- excess_count, excess_count)
            else
              []
            end
          end


          def existing_objects
            @old_objects.slice(0, existing_count)
          end

        end
      end
    end
  end
end
