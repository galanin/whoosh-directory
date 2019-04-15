module Staff
  class HistoryAPI < Grape::API

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
        units = Unit.only(:short_id, :short_title, :long_title).where(destroyed_at: nil).in(short_id: unit_ids)

        present :histories, histories
        present :employment, employments
        present :people, people
        present :units, units
      end


      params {
        requires :id, type: String
      }

      desc 'Create object HistoryPerson class if today was not created or touch updated_at field if exist'
      post 'people/:id' do
        @user_information.create_or_update_history_person(params[:id])
      end


      params {
        requires :id, type: String
      }

      desc 'Create object HistoryUnit class if today was not created or touch updated_at field if exist'
      post 'units/:id' do
        @user_information.create_or_update_history_unit(params[:id])
      end


      params {
        requires :search_query, type: String
      }

      desc 'Create object HistorySearch class if today was not created or touch updated_at field if exist'
      post 'search/:search_query' do
        @user_information.create_or_update_history_search(params[:search_query])
      end


      params {
        requires :id, type: String
      }

      desc 'Destroy History by id'
      delete ':id' do
        @user_information.destroy_history(params[:id])
      end

    end

  end
end
