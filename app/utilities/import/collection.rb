module Utilities
  module Import
    module Collection
      extend ActiveSupport::Concern

      class_methods do

        attr_accessor :entity_class, :object_class

      end


      included do

        def initialize
          @entities   = {}
          @black_list = Utilities::Import::BlackList.new
        end


        def new_entity
          self.class.entity_class.new(self.class.object_class)
        end


        def [](external_id)
          @entities[external_id]
        end


        def count
          @entities.count
        end


        def add_black_list(id)
          @black_list.black_list[id] = "1"
        end


        def present_in_black_list?(id)
          @black_list.black_list.has_key?(id)
        end


        def fetch_from_db
          self.class.object_class.where(destroyed_at: nil).each do |db_object|
            add_old_object(db_object)
          end
        end


        def add_new_data(new_data)
          entity = sure_entity_exists(new_data.external_id)
          entity.add_new_data(new_data)
        end


        def add_old_object(old_object)
          if old_object.external_id.present?
            entity = sure_entity_exists(old_object.external_id)
            entity.add_old_object(old_object)
          end
        end


        def remove_by_id(external_id)
          @entities.delete(external_id)
        end


        def short_id_by_external_id(external_id)
          @entities[external_id].old_object.short_id
        end


        def object_by_external_id(external_id)
          @entities[external_id]&.old_object
        end


        def short_ids_by_external_ids(external_ids)
          external_ids&.map { |id| short_id_by_external_id(id) }
        end


        def objects_by_external_ids(external_ids)
          external_ids&.map { |id| object_by_external_id(id) }
        end


        def build_new_objects
          new_entities.each do |entity|
            entity.build_new_object
          end
        end


        def create_new_objects
          new_entities.each do |entity|
            entity.old_object.save
          end
        end


        def drop_stale_objects
          stale_entities.each do |entity|
            entity.drop_stale_object
          end
        end


        def flush_to_db
          fresh_entities.each do |entity|
            entity.flush_to_db
          end
        end


        def entities_by_ids(external_ids)
          @entities.slice(*external_ids).values
        end


        def new_entities
          @entities.values.select { |entity| entity.new? }
        end


        def fresh_entities
          @entities.values.reject { |entity| entity.stale? }
        end


        def stale_entities
          @entities.values.select { |entity| entity.stale? }
        end


        private


        def sure_entity_exists(external_id)
          @entities[external_id] ||= new_entity
        end

      end
    end
  end
end
