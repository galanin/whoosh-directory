module FetchingHelpers

  def fetch_search_result_unit_extras(search_result)
    unit_short_ids = search_result.map(&:unit_id).compact
    Unit.in(short_id: unit_short_ids).to_a
  end


  def fetch_search_result_employments(search_result)
    employment_short_ids = search_result.map(&:employ_ids).compact.flatten
    Employment.in(short_id: employment_short_ids).to_a
  end


  def fetch_search_result_people(search_result)
    person_short_ids = search_result.map(&:person_id).compact
    Person.in(short_id: person_short_ids).to_a
  end

end
