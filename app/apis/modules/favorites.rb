module Staff
  class FavoriteAPI < Grape::API

    namespace 'favorites' do

      namespace 'units' do

        desc 'Returns all FavoriteUnits records from UserInformation'
        get do
          unit_ids = @user_information.favorite_unit.pluck(:unit_short_id)
          units = Unit.only(:short_id, :short_title, :long_title, :alpha_sort).where(destroyed_at: nil).in(short_id: unit_ids)

          present :favorite_units, @user_information.favorite_unit
          present :unit_titles, units
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

  end
end
