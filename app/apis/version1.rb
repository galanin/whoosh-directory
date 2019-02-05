module Staff
  class API < Grape::API

    rescue_from Mongoid::Errors::DocumentNotFound do |e|
      error!(e, 404)
    end


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
        present :unit_titles, [unit.as_json.slice('id', 'long_title', 'short_title')]

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


    get 'units/titles/:where' do
      unit_ids = params[:where].split(',')
      units = Unit.only(:short_id, :short_title, :long_title).in(short_id: unit_ids)
      present :unit_titles, units
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
      search_query = SearchQuery.new(params[:q])

      if search_query.birthday?
        birthday_interval = search_query.birthday_interval

        people = get_birthday_entity(Person, birthday_interval.first)
        employments = Employment.where(destroyed_at: nil).in(person_short_id: people.map(&:short_id))
        external_contacts = get_birthday_entity(ExternalContact, birthday_interval.first)
        results = get_birthday_results(people, external_contacts)

        present :birthday_interval, birthday_interval
        present :birthdays, results
      elsif search_query.common?
        search_result = SearchEntry.query(params[:q], params[:max])
        present :results, search_result

        employments = fetch_search_result_employments(search_result)
        external_contacts = fetch_search_result_external_contacts(search_result)
        people = fetch_search_result_people(search_result)

        present :unit_titles, fetch_search_result_unit_extras(search_result, employments)
      end

      present :type,              search_query.type
      present :query,             params[:q]
      present :employments,       employments
      present :people,            people
      present :external_contacts, external_contacts
    end


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


    get 'employments/:who' do
      employ_ids = params[:who].split(',')

      employments = Employment.in(short_id: employ_ids)
      present :employments, employments

      people = Person.in(short_id: employments.map(&:person_short_id))
      present :people, people
    end


    namespace 'user_information' do

      before do
        current_session = UserSession.find!(params[:session_token])
        @user_information = current_session.user_information
      end

      after do
        @user_information.save if @user_information.changed?
      end

      namespace 'expanded_units' do

        desc 'Returns expanded_units field From UserInformation object'
        get do
          present :expanded_units, @user_information.expanded_units
        end


        desc 'Add unit_ids to UserInformation object expanded_units field'
        post ':unit_id' do
          unit_ids = params[:unit_id].to_s.split(',').presence.compact
          if unit_ids.present?
            @user_information.add_to_expanded_units(unit_ids)
          end
        end


        desc 'Remove unit_id from UserInformation object expanded_units field'
        post ':unit_id/collapse' do
          if params[:unit_id].present?
            @user_information.delete_from_expanded_unit(params[:unit_id])
          end
        end

      end


      namespace 'to_call' do

        after do
          present :unchecked, @user_information.to_call_unchecked_ids
          present :checked, @user_information.to_call_checked_ids
        end

        desc 'Returns all ToCalls records from UserInformation'
        get do
          present :data, @user_information.to_call.as_json
        end


        desc 'Create object ToCall class or set checked if object exist '
        post ':employ_id' do
          to_call_entity = @user_information.create_to_call(params[:employ_id])

          present :to_call, to_call_entity
        end


        desc "Find object ToCall class by short_id and set unchecked"
        post ':employ_id/check' do
          to_call_entity = @user_information.check_to_call(params[:employ_id])

          present :to_call, to_call_entity
        end


        desc "Find object ToCall class and destroy it"
        delete ':employ_id' do
          if params[:employ_id].present?
            @user_information.destroy_to_call(params[:employ_id])
          end
        end

      end


      namespace 'favorites' do

        desc 'Return all Favorites'
        get do
          #TODO
        end


        desc 'Add Favorite'
        post ':type/:id' do
          #TODO
        end


        desc 'Delete Favorite'
        delete ':id' do
          #TODO
        end

      end


      namespace 'history' do

        desc 'Return all History'
        get do
          #TODO
        end


        desc 'Add History'
        post ':type/:id' do
          #TODO
        end

      end

    end

  end
end
