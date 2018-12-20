module Utilities
  class SearchResultList

    attr_reader :results


    def initialize(object_array = [])
      @results = object_array.map { |object| SearchResult.new(object) }
    end


    def add_object(object)
      @results << SearchResult.new(object)
    end


    def add_results(results)
      @results.push(*results)
    end


    def +(other_results)
      new_result_list = SearchResultList.new
      new_result_list.add_results(@results)
      new_result_list.add_results(other_results.results)
      new_result_list
    end


    def group_by_birthday
      @results.group_by(&:birthday).map { |bday, results| SearchResultBirthday.new(bday, results) }
    end

  end
end
