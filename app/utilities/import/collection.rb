module Utilities
  module Import
    module Collection

      def initialize(object_class)
        @object_class = object_class
        @entities     = {}
        @black_list   = Utilities::Import::BlackList.new
      end


      def [](external_id)
        @entities[external_id]
      end


      def add_black_list(id)
        @black_list.black_list[id] = "1"
      end


      def present_in_black_list?(id)
        @black_list.black_list.has_key?(id)
      end


      def fetch_from_db
        @object_class.where(destroyed_at: nil).each do |db_object|
          add_old_object(db_object)
        end
      end


      def add_new_data(new_data)
        @entities[new_data.external_id] ||= Utilities::Import::Entity.new(@object_class)
        @entities[new_data.external_id].new_data = new_data
      end


      def add_old_object(old_object)
        if old_object.external_id.present?
          @entities[old_object.external_id] ||= Utilities::Import::Entity.new(@object_class)
          @entities[old_object.external_id].old_object = old_object
        end
      end


      def remove_by_id(external_id)
        @entities.delete(external_id)
      end


      def short_id_by_external_id(external_id)
        @entities[external_id].old_object.short_id
      end


      def short_ids_by_external_ids(external_ids)
        external_ids.map { |id| short_id_by_external_id(id) }
      end


      def build_new_objects
        @entities.each do |id, entity|
          entity.build_new_object if entity.new?
        end
      end


      def drop_stale_objects
        @entities.each do |id, entity|
          if entity.stale?
            entity.drop_stale_object
          end
        end
      end


      def flush_to_db
        @entities.each do |id, entity|
          unless entity.stale?
            entity.flush_to_db
          end
        end
      end

      def entites_by_ids(external_ids)
        @entities.slice(*external_ids).values
      end

    end
  end
end
