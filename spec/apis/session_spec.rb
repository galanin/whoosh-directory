require 'spec_helper'

describe Staff::API do
  include Rack::Test::Methods

  before do
    create_structure
  end

  let (:app) { Staff::API }

  context 'GET /api/session' do
    it 'create session' do
      get '/api/session'
      expect(last_response).to has_status_200
      expect(last_response_body.session_token).not_to be_empty
    end
  end

end
