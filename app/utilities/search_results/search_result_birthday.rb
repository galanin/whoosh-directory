module Utilities
  class SearchResultBirthday
    include FormatBirthday

    attr_reader :birthday


    def initialize(birthday, results)
      @birthday = birthday
      @results = results
    end


    def as_json(options = nil)
      {
        'birthday'       => birthday,
        'date_formatted' => birthday_formatted,
        'results'        => @results.sort_by { |object| object.sorting_title },
      }
    end

  end
end
