require_relative 'to_call.rb'
require_relative 'favorite.rb'
require_relative 'history.rb'

module Staff
  class UserInformationAPI < Grape::API

    namespace 'user_information' do

      before do
        current_session = UserSession.find_or_create(params[:session_token])
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


        params {
          requires :unit_id, type: String
        }

        desc 'Add unit_ids to UserInformation object expanded_units field'
        post ':unit_id' do
          unit_ids = params[:unit_id].to_s.split(',').presence.compact
          if unit_ids.present?
            @user_information.add_to_expanded_units(unit_ids)
          end
        end


        params {
          requires :unit_id, type: String
        }

        desc 'Remove unit_id from UserInformation object expanded_units field'
        delete ':unit_id' do
          if params[:unit_id].present?
            @user_information.delete_from_expanded_unit(params[:unit_id])
          end
        end

      end

      mount Staff::ToCallAPI
      mount Staff::FavoriteAPI
      mount Staff::HistoryAPI

    end

  end
end
