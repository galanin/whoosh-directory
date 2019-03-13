module Staff
  class ToCallAPI < Grape::API

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


      params {
        requires :employ_id, type: String
      }

      desc 'Create new or set checked whom-to-call if one already exists'
      post '/employment/:employ_id' do
        employment_to_call = @user_information.to_call.add_employment(params[:employ_id])

        present :to_call, employment_to_call
        present_unchecked_and_checked_today(@user_information)
      end


      params {
        requires :contact_id, type: String
      }

      desc 'Create object ToCall class or set checked if object exist '
      post '/contact/:contact_id' do
        contact_to_call = @user_information.to_call.add_contact(params[:contact_id])

        present :to_call, contact_to_call
        present_unchecked_and_checked_today(@user_information)
      end


      params {
        requires :employ_id, type: String
      }

      desc "Find object ToCall class by short_id and set unchecked"
      post '/employment/:employ_id/check' do
        employment_to_call = @user_information.to_call.check_employment(params[:employ_id])

        present :to_call, employment_to_call
        present_unchecked_and_checked_today(@user_information)
      end


      params {
        requires :contact_id, type: String
      }

      desc "Find object ToCall class by short_id and set unchecked"
      post '/contact/:contact_id/check' do
        contact_to_call = @user_information.to_call.check_contact(params[:contact_id])

        present :to_call, contact_to_call
        present_unchecked_and_checked_today(@user_information)
      end


      params {
        requires :employ_id, type: String
      }

      desc "Find object ToCall class and destroy it"
      delete '/employment/:employ_id' do
        @user_information.to_call.destroy_employment(params[:employ_id])

        present_unchecked_and_checked_today(@user_information)
      end


      params {
        requires :contact_id, type: String
      }

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

  end
end
