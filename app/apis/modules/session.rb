module Staff
  class SessionAPI < Grape::API

    get :session do
      current_session = UserSession.find_or_create(params[:session_token])
      present :session_token, current_session.token
    end

  end
end
