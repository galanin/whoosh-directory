require_relative 'to_call.rb'
require_relative 'favorite.rb'
require_relative 'history.rb'
require_relative 'settings.rb'

module Staff
  class UserInformationAPI < Grape::API

    before do
      set_cache_header
    end

    namespace 'user_information' do

      before do
        current_session = UserSession.find_or_create(params[:session_token])
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
      mount Staff::SettingsAPI

    end

  end
end
