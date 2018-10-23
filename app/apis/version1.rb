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
      present :units, Unit.only(:short_id, :level, :list_title, :child_ids).where(destroyed_at: nil)
    end


    get 'units/:unit_id' do
      if params.key? :unit_id
        unit = Unit.only(:short_id, :long_title, :short_title, :employ_ids).find_by!(short_id: params[:unit_id])
        present :unit_extra, [unit]

        present :employments, unit.employments.order(:in_unit_rank.asc)

        people = Person.find(unit.employments.map(&:person_id))
        present :people, people
      end
    end


    post 'units/:unit_id/expand' do
      current_session = UserSession.find(params[:session_token])
      if params[:unit_id].present? && current_session && ! current_session.data[:expanded_units].include?(params[:unit_id])
        current_session.data[:expanded_units] << params[:unit_id]
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
      present :results, search_result

      present :unit_extras, fetch_search_result_unit_extras(search_result)
      present :employments, fetch_search_result_employments(search_result)
      present :people,      fetch_search_result_people(search_result)
    end

  end
end
