module Staff
  class API < Grape::API

    format :json
    prefix :api
    helpers FetchingHelpers


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
                only(:short_id, :level, :list_title, :child_ids, :employ_ids).
                where(destroyed_at: nil)
    end


    get 'units/:unit_id' do
      if params.key? :unit_id
        unit = Unit.find_by!(short_id: params[:unit_id])
        present :unit_extras, [unit.as_json.slice('id', 'long_title', 'short_title')]

        employments = Employment.in(short_id: unit.employ_ids)
        present :employments, employments

        people = Person.in(short_id: employments.map(&:person_short_id))
        present :people, people
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

      present :unit_extras, fetch_search_result_unit_extras(search_result, employments)
      present :employments, employments
      present :people,      fetch_search_result_people(search_result)
    end

  end
end
