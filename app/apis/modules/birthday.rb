module Staff
  class BirthdayAPI < Grape::API

    params {
      requires :when, type: String, regexp: /^\d\d-\d\d(,\d\d-\d\d)*$/
    }

    get 'birthday/:when' do
      dates = params[:when].split(',')

      people = get_birthday_entity(Person, dates)
      employments = Employment.where(destroyed_at: nil).in(person_short_id: people.map(&:short_id))
      external_contacts = get_birthday_entity(ExternalContact, dates)
      results = get_birthday_results(people, external_contacts)

      present birthdays: results
      present :people, people
      present :employments, employments
      present :external_contacts, external_contacts
    end

  end
end
