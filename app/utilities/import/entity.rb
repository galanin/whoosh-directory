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
        build_embedded_new_object
      end


      def build_embedded_new_object
        embedded_relations = @object_class.embedded_relations

        embedded_relations.each_key do |embedded_name|
          if new_data.send(embedded_name).present?
            object_attributes = new_data.object_attributes[embedded_name.to_sym][:attributes]
            self.build_embeded_document(embedded_name, object_attributes)
          end
        end
      end


      def drop_stale_object
        old_object.set(destroyed_at: Time.now)
      end


      def flush_to_db
        attributes = new_data.attributes

        old_object.assign_attributes(attributes.compact)
        update_embedded_attributes
        old_object.save

        unset_nil_attributes(attributes)
      end


      def update_embedded_attributes
        embedded_relations = @object_class.embedded_relations

        embedded_relations.each_key do |embedded_name|
          if new_data.send(embedded_name).present?
            embedded_object_attributes = new_data.object_attributes[embedded_name.to_sym][:attributes]

            if old_object.send(embedded_name).present?
              assign_attributes_embeded_document(embedded_name, embedded_object_attributes)
            else
              build_embeded_document(embedded_name, embedded_object_attributes)
            end
          else
            delete_embeded_document(embedded_name)
          end
        end
      end


      def build_embeded_document(embedded_name, attributes)
        old_object.send("build_#{embedded_name}", attributes)
      end


      def assign_attributes_embeded_document(embedded_name, attributes)
        old_object.send(embedded_name).assign_attributes(attributes)
      end


      def delete_embeded_document(embedded_name)
        old_object.send("#{embedded_name}=",nil)
      end


      def unset_nil_attributes(attributes)
        nil_attribute_names = attributes.select { |name, value| value.nil? }.map(&:first)
        nil_attribute_names.each { |name| old_object.unset(name) }
      end

    end
  end
end
