module Importable
  extend ActiveSupport::Concern


  class_methods do

    def build_new_object(new_data)
      new_object = create(new_data.attributes)
      new_object.build_new_embedded_objects(new_data.embedded_attributes) if new_data.respond_to?(:embedded_attributes)
      new_object
    end

  end


  included do

    field :external_id,     type: String
    validates :external_id, presence: true


    def build_new_embedded_objects(embedded_attributes)
      embedded_attributes.each do |relation_name, values|
        attributes = values[:attributes]
        build_embedded_object(relation_name, attributes) if attributes.present?
      end
    end


    def drop
      set(destroyed_at: Time.now)
    end


    def flush_to_db(new_data)
      attributes = new_data.attributes # do not compact here coz need to unset the nil fields below

      assign_attributes(attributes.compact)
      update_embedded_attributes(new_data.embedded_attributes) if new_data.respond_to?(:embedded_attributes)
      save! if changed?

      unset_nil_attributes(attributes)
    end


    def update_embedded_attributes(embedded_attributes)
      embedded_attributes.each do |relation_name, values|
        attributes = values[:attributes]
        if attributes.present?
          if send(relation_name).present?
            assign_embedded_attributes(relation_name, attributes)
          else
            build_embedded_object(relation_name, attributes)
          end
        else
          delete_embedded_document(relation_name)
        end
      end
    end


    def build_embedded_object(relation_name, attributes)
      send("build_#{relation_name}", attributes)
    end


    def assign_embedded_attributes(relation_name, attributes)
      send(relation_name).assign_attributes(attributes)
    end


    def delete_embedded_document(relation_name)
      send("#{relation_name}=",nil)
    end


    def unset_nil_attributes(attributes)
      attributes.each do |name, value|
        if value.nil? && has_attribute?(name)
          unset(name)
        end
      end
    end

  end

end
