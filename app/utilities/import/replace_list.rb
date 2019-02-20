module Utilities
  module Import
    class ReplaceList

      def initialize()
        @list = {}
      end

      def add_to_list(hash)
        @list[hash["employment"]] = {
          from_unit:        hash["from"]["unit"],
          from_post_title:  hash["from"]["post_title"],
          to_unit:          hash["to"]["unit"],
          to_post_title:    hash["to"]["post_title"],
        }
      end

      def import(source_data)
        source_data["employment_replacement"].each do |record|
          add_to_list(record)
        end
      end


      def replace(collection)
        @list.each do |employment_id, data|
          collection_entity = collection[employment_id]
          if collection_entity.new_data.post_title == data[:from_post_title] && collection_entity.new_data.unit_external_id == data[:from_unit]
            collection_entity.new_data.post_title = data[:to_post_title] if data[:to_post_title].present?
            collection_entity.new_data.unit_external_id = data[:to_unit] if data[:from_unit].present?
          end
        end
      end

    end
  end
end
