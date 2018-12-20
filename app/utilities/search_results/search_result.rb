module Utilities
  class SearchResult

    def initialize(result_object)
      @object = result_object
    end


    def as_json
      case @object.class
      when Person
        {
          'person_id' => @object.short_id,
          'employ_ids' => @object.employ_ids,
        }
      when ExternalContact
        {
          'contact_id' => @object.short_id,
        }
      else
        {}
      end
    end


    def sorting_title
      @object.sorting_title
    end


    def birthday
      @object.birthday
    end

  end
end
