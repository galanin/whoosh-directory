module Staff
  class SettingsAPI < Grape::API

    namespace 'settings' do

      desc 'Get user\'s settings'
      get do
        present settings: @user_information.settings || {}
      end


      params {
        requires :key, type: String
        requires :value
      }

      desc 'Set a separate user setting value'
      put do
        @user_information.settings ||= {}
        @user_information.settings[params[:key]] = params[:value]
      end

    end

  end
end
