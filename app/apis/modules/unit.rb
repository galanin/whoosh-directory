module Staff
  class UnitAPI < Grape::API

    get :units do
      present :units,
              Unit.
                only(:short_id, :level, :list_title, :child_ids, :employ_ids, :contact_ids).
                where(destroyed_at: nil)
    end


    params {
      requires :unit_id, type: String
    }

    get 'units/:unit_id' do
      if params.key? :unit_id
        unit = Unit.find_by!(short_id: params[:unit_id])
        present :units, [unit.as_json.slice('id', 'long_title', 'short_title', 'alpha_sort')]

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


    params {
      requires :where, type: String
    }

    get 'units/titles/:where' do
      unit_ids = params[:where].split(',')
      units = Unit.only(:short_id, :short_title, :long_title, :alpha_sort).in(short_id: unit_ids)
      present :units, units
    end


    params {
      requires :unit_id, type: String
    }

    post 'units/:unit_id/expand' do
      current_session = UserSession.find(params[:session_token])
      unit_ids = params[:unit_id].to_s.split(',').presence.compact
      if unit_ids.present? && current_session && (new_unit_ids = unit_ids - current_session.data[:expanded_units]).present?
        current_session.data[:expanded_units] += new_unit_ids
        current_session.save
      end
    end


    params {
      requires :unit_id, type: String
    }

    post 'units/:unit_id/collapse' do
      current_session = UserSession.find(params[:session_token])
      if params[:unit_id].present? && current_session && current_session.data[:expanded_units].include?(params[:unit_id])
        current_session.data[:expanded_units].delete(params[:unit_id])
        current_session.save
      end
    end

  end
end
