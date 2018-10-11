module Staff
  class API < Grape::API

    format :json
    prefix :api

    before do
      header 'Access-Control-Allow-Origin', '*'
    end


    after_validation do
      UserSession.setup(params[:session_token])
      present :session_token, UserSession.current.token
    end


    get :bootstrap do
      units = Unit.only(:short_id, :level, :list_title, :child_ids)
      present :units, units
      present :expanded_units, UserSession.current.data[:expanded_units]
    end


    get 'units/:unit_id' do
      if params.key? :unit_id
        unit = Unit.only(:short_id, :long_title, :short_title, :employ_ids).find_by!(short_id:  params[:unit_id])
        present :unit_extra, [unit]

        present :employments, unit.employments.order(:in_unit_rank.asc)

        people = Person.find(unit.employments.map(&:person_id))
        present :people, people
      end
    end


    post 'units/:unit_id/expand' do
      if params.key?(:unit_id) && params[:unit_id].present? && ! UserSession.current.data[:expanded_units].include?(params[:unit_id])
        UserSession.current.data[:expanded_units] << params[:unit_id]
        UserSession.current.save
      end
    end


    post 'units/:unit_id/collapse' do
      if params.key?(:unit_id) && params[:unit_id].present?
        UserSession.current.data[:expanded_units].delete(params[:unit_id])
        UserSession.current.save
      end
    end

  end
end
