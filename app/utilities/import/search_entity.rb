module Utilities
  module Import
    class SearchEntity

      attr_reader :keywords, :weights, :sub_order, :searchable_object
      attr_accessor :search_entry


      def initialize(searchable_object = nil)
        @keywords = []
        @weights = {}
        @sub_order = ''
        @searchable_object = searchable_object
      end


      def new?
        keywords.present? && search_entry.nil?
      end


      def stale?
        keywords.empty? && search_entry.present?
      end


      def add_keyword(keyword, priority)
        @keywords << keyword
        @weights[keyword] ||= 0
        @weights[keyword] = [priority, @weights[keyword]].max
      end


      def set_sub_order(sub_order)
        @sub_order = sub_order
      end


      def build_new_entry
        @search_entry = SearchEntry.new(search_entry_attributes)
      end


      def drop_stale_entry
        search_entry.destroy
      end


      def flush_to_db
        search_entry.attributes = search_entry_attributes
        search_entry.keywords = keywords.sort.uniq
        search_entry.weights = weights
        search_entry.sub_order = sub_order
        search_entry.searchable = searchable_object
        search_entry.save! if search_entry.changed?
      end


      def search_entry_attributes
        case searchable_object
        when Unit
          {
            unit_id: searchable_object.short_id,
          }
        when Person
          {
            person_id: searchable_object.short_id,
            employ_ids: searchable_object.employ_ids,
          }
        else
          {}
        end
      end

    end
  end
end
