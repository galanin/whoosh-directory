module FetchingHelpers

  def fetch_search_result_unit_extras(search_results, employments)
    unit_short_ids = search_results.map(&:unit_id).compact
    unit_short_ids2 = employments.map(&:unit_short_id).compact
    Unit.only(:short_id, :long_title, :short_title).in(short_id: (unit_short_ids + unit_short_ids2).uniq).to_a
  end


  def fetch_search_result_employments(search_results)
    employment_short_ids = search_results.map(&:employ_ids).compact.flatten
    Employment.in(short_id: employment_short_ids).to_a
  end


  def fetch_search_result_people(search_results)
    person_short_ids = search_results.map(&:person_id).compact
    Person.in(short_id: person_short_ids).to_a
  end


  def fetch_search_result_external_contacts(search_results)
    external_contact_short_ids = search_results.map(&:contact_id).compact.flatten
    ExternalContact.in(short_id: external_contact_short_ids).to_a
  end

end
