module BirthdayHelpers

  def get_birthday_entity(model, dates)
    model.where(destroyed_at: nil).in(birthday: dates).to_a
  end

  def get_birthday_results(people, external_contacts)
    people_results = Utilities::SearchResultList.new(people)
    contact_results = Utilities::SearchResultList.new(external_contacts)
    results = people_results + contact_results

    results.group_by_birthday
  end

end
