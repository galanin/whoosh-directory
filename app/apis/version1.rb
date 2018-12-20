module Staff
  class API < Grape::API

    format :json
    prefix :api
    helpers FetchingHelpers, BirthdayHelpers


    before do
      header 'Access-Control-Allow-Origin', '*'
      if request.options?
        header 'Access-Control-Allow-Headers', 'Content-Type'
      end
    end


    get :session do
      current_session = UserSession.find_or_create(params[:session_token])
      present :session_token, current_session.token
      present :expanded_units, current_session.data[:expanded_units]
    end


    get :units do
      present :units,
              Unit.
                only(:short_id, :level, :list_title, :child_ids, :employ_ids, :contact_ids).
                where(destroyed_at: nil)
    end


    get 'units/:unit_id' do
      if params.key? :unit_id
        unit = Unit.find_by!(short_id: params[:unit_id])
        present :unit_extras, [unit.as_json.slice('id', 'long_title', 'short_title')]

        unless unit.employ_ids.nil?
          employments = Employment.in(short_id: unit.employ_ids)
          present :employments, employments

          people = Person.in(short_id: employments.map(&:person_short_id))
          present :people, people
        end

        unless unit.contact_ids.nil?
          external_contacts = ExternalContact.in(short_id: unit.contact_ids)
          present :external_contacts, external_contacts
        end
      end
    end


    post 'units/:unit_id/expand' do
      current_session = UserSession.find(params[:session_token])
      unit_ids = params[:unit_id].to_s.split(',').presence.compact
      if unit_ids.present? && current_session && (new_unit_ids = unit_ids - current_session.data[:expanded_units]).present?
        current_session.data[:expanded_units] += new_unit_ids
        current_session.save
      end
    end


    post 'units/:unit_id/collapse' do
      current_session = UserSession.find(params[:session_token])
      if params[:unit_id].present? && current_session && current_session.data[:expanded_units].include?(params[:unit_id])
        current_session.data[:expanded_units].delete(params[:unit_id])
        current_session.save
      end
    end


    params {
      requires :q, type: String
      optional :max, type: Integer, default: 20
    }
    get :search do
      search_result = SearchEntry.query(params[:q], params[:max])
      present :query, params[:q]
      present :results, search_result

      employments = fetch_search_result_employments(search_result)
      external_contacts = fetch_search_result_external_contacts(search_result)

      present :employments,       employments
      present :people,            fetch_search_result_people(search_result)
      present :external_contacts, external_contacts
    end


    params {
      requires :when, type: String, regexp: /^\d\d-\d\d(,\d\d-\d\d)*$/
    }
    get 'birthday/:when' do
      dates = params[:when].split(',')

      people = get_birthday_entity(Person, dates)
      employments = Employment.in(person_short_id: people.map(&:short_id))
      external_contacts = get_birthday_entity(ExternalContact, dates)

      people_results = Utilities::SearchResultList.new(people)
      contact_results = Utilities::SearchResultList.new(external_contacts)
      results = people_results + contact_results

      present results: results.group_by_birthday
      present :people, people
      present :employments, employments
      present :external_contacts, external_contacts
    end

  end
end
