module Staff
  class API < Grape::API

    rescue_from Mongoid::Errors::DocumentNotFound do |e|
      error!(e, 404)
    end


    format :json
    prefix :api
    helpers FetchingHelpers, BirthdayHelpers, ToCallHelpers


    before do
      header 'Access-Control-Allow-Origin', '*'
    end


    options '*' do
      header 'Access-Control-Allow-Methods', 'OPTIONS, GET, POST, PUT, DELETE'
      header 'Access-Control-Allow-Headers', 'Content-Type'
    end


    get :session do
      current_session = UserSession.find_or_create(params[:session_token])
      present :session_token, current_session.token
    end


    get 'units/:unit_id' do
      if params.key? :unit_id
        unit = Unit.api_fields.find_by!(short_id: params[:unit_id])
        present :units, [unit]
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

        present :units, fetch_search_result_unit_extras(search_result, employments)
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

      employments = Employment.where(destroyed_at: nil).in(short_id: employ_ids)
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


      namespace 'expanded_nodes' do

        desc 'Get all expanded node ids'
        get do
          present :expanded_nodes, @user_information.expanded_node_ids
        end


        desc 'Add the new node ids to the list of expanded nodes'
        post ':node_ids' do
          node_ids = params[:node_ids].to_s.split(',').presence.compact
          if node_ids.present?
            @user_information.expand_nodes(node_ids)
          end
        end


        desc 'Remove the single node id from the list of expanded nodes'
        delete ':node_id' do
          if params[:node_id].present?
            @user_information.collapse_node(params[:node_id])
          end
        end

      end


      namespace 'to_call' do

        desc 'Returns unchecked and today checked ToCalls records from UserInformation'
        get do
          to_call = @user_information.to_call.unchecked_and_checked_today
          employments = Employment.where(destroyed_at: nil).in(short_id: to_call.map(&:employment_short_id))
          contacts = ExternalContact.where(destroyed_at: nil).in(short_id: to_call.map(&:contact_short_id))
          people = Person.in(short_id: employments.pluck(:person_short_id))

          present :people, people
          present :employments, employments
          present :contacts, contacts
          present :data, to_call
          present_unchecked_and_checked_today(@user_information)
        end


        desc 'Create new or set checked whom-to-call if one already exists'
        post '/employment/:employ_id' do
          employment_to_call = @user_information.to_call.add_employment(params[:employ_id])

          present :to_call, employment_to_call
          present_unchecked_and_checked_today(@user_information)
        end


        desc 'Create object ToCall class or set checked if object exist '
        post '/contact/:contact_id' do
          contact_to_call = @user_information.to_call.add_contact(params[:contact_id])

          present :to_call, contact_to_call
          present_unchecked_and_checked_today(@user_information)
        end


        desc "Find object ToCall class by short_id and set unchecked"
        post '/employment/:employ_id/check' do
          employment_to_call = @user_information.to_call.check_employment(params[:employ_id])

          present :to_call, employment_to_call
          present_unchecked_and_checked_today(@user_information)
        end


        desc "Find object ToCall class by short_id and set unchecked"
        post '/contact/:contact_id/check' do
          contact_to_call = @user_information.to_call.check_contact(params[:contact_id])

          present :to_call, contact_to_call
          present_unchecked_and_checked_today(@user_information)
        end


        desc "Find object ToCall class and destroy it"
        delete '/employment/:employ_id' do
          @user_information.to_call.destroy_employment(params[:employ_id])

          present_unchecked_and_checked_today(@user_information)
        end


        desc "Find object ToCall class and destroy it"
        delete '/contact/:contact_id' do
          @user_information.to_call.destroy_contact(params[:contact_id])

          present_unchecked_and_checked_today(@user_information)
        end


        params do
          requires :year, type: Integer, regexp: /\d{4}/
          requires :month, type: Integer, values: 0..12
          optional :day, type: Integer, values: 0..31
        end

        desc 'Return checked ToCalls records from day or from month.'
        get '/history' do
          to_call = @user_information.to_call.history(params[:year], params[:month], params[:day])
          employments = Employment.where(destroyed_at: nil).in(short_id: to_call.map(&:employment_short_id))
          contacts = ExternalContact.where(destroyed_at: nil).in(short_id: to_call.map(&:contact_short_id))
          people = Person.in(short_id: employments.pluck(:person_short_id))

          present :people, people
          present :employments, employments
          present :contacts, contacts
          present :data_checked, to_call
        end

      end


      namespace 'favorites' do

        namespace 'units' do

          desc 'Returns all FavoriteUnits records from UserInformation'
          get do
            unit_ids = @user_information.favorite_unit.pluck(:unit_short_id)
            units = Unit.api_fields.where(destroyed_at: nil).in(short_id: unit_ids)

            present :favorite_units, @user_information.favorite_unit
            present :units, units
          end


          desc 'Create object FavoriteUnits class if not exist. After sort all FavoriteUnits records'
          post ':id' do
            @user_information.create_favorite_unit(params[:id])
            present :favorite_units, @user_information.favorite_unit
          end


          desc 'Find object FavoriteUnit class and destroy it'
          delete ':id' do
            @user_information.destroy_favorite_unit(params[:id])
            present :favorite_units, @user_information.favorite_unit
          end

        end


        namespace 'people' do

          desc 'Returns all FavoritePersons records from UserInformation'
          get do
            employment_ids = @user_information.favorite_person.with_employment.pluck(:favorable_short_id)
            employments = Employment.where(destroyed_at: nil).in(short_id: employment_ids)
            people = Person.in(short_id: employments.map(&:person_short_id))
            external_contact_ids = @user_information.favorite_person.with_external_contact.pluck(:favorable_short_id)
            external_contacts = ExternalContact.where(destroyed_at: nil).in(short_id: external_contact_ids)

            present :favorite_people, @user_information.favorite_person
            present :employments, employments
            present :people, people
            present :external_contacts, external_contacts
          end

          namespace 'employments' do

            desc 'Create object FavoritePerson class if not exist. After sort all FavoritePerson records'
            post ':id' do
              @user_information.create_favorite_person('employment', params[:id])
              present :favorite_people, @user_information.favorite_person
            end

            desc 'Find object FavoritePersons class by Employment id and destroy it'
            delete ':id' do
              @user_information.destroy_favorite_person('employment', params[:id])
              present :favorite_people, @user_information.favorite_person
            end

          end


          namespace 'contacts' do

            desc 'Create object FavoritePerson class if not exist. After sort all FavoritePerson records'
            post ':id' do
              @user_information.create_favorite_person('external_contact', params[:id])
              present :favorite_people, @user_information.favorite_person
            end

            desc 'Find object FavoritePersons by ExternalContact id and destroy it'
            delete ':id' do
              @user_information.destroy_favorite_person('external_contact', params[:id])
              present :favorite_people, @user_information.favorite_person
            end

          end

        end

      end


      namespace 'histories' do

        params {
          requires :begin_date, type: String, regexp: /^\d\d\d\d-\d\d-\d\d$/
          optional :end_date, type: String, regexp: /^\d\d\d\d-\d\d-\d\d$/
        }

        desc 'Return all Histories record from period begin_date..end_date or from day if end_date = nil'
        get do
          histories = @user_information.get_histories_by_date(params[:begin_date], params[:end_date])

          employment_ids = histories.person.map(&:employment_short_id)
          unit_ids = histories.unit.map(&:unit_short_id)

          employments = Employment.where(destroyed_at: nil).in(short_id: employment_ids)
          people = Person.in(short_id: employments.map(&:person_short_id))
          units = Unit.api_fields.where(destroyed_at: nil).in(short_id: unit_ids)

          present :histories, histories
          present :employment, employments
          present :people, people
          present :units, units
        end


        desc 'Create object HistoryPerson class if today was not created or touch updated_at field if exist'
        post 'people/:id' do
          @user_information.create_or_update_history_person(params[:id])
        end


        desc 'Create object HistoryUnit class if today was not created or touch updated_at field if exist'
        post 'units/:id' do
          @user_information.create_or_update_history_unit(params[:id])
        end


        desc 'Create object HistorySearch class if today was not created or touch updated_at field if exist'
        post 'search/:search_query' do
          @user_information.create_or_update_history_search(params[:search_query])
        end


        desc 'Destroy History by id'
        delete ':id' do
          @user_information.destroy_history(params[:id])
        end

      end

    end


    mount Staff::NodesAPI

  end
end
