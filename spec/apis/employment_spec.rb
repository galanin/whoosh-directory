require 'spec_helper'

describe Staff::API do
  include Rack::Test::Methods

  before do
    create_structure
  end

  let (:app) { Staff::API }

  context 'check employments api' do
    it 'get /api/employments' do
      employments_ids = Employment.pluck(:short_id).sample(6)

      get "api/employments/#{employments_ids.join(',')}"  # -> last_response
      response_ids = get_ids(last_response_body.employments, 'id')

      expect(last_response).to has_status_200
      expect(employments_ids).to match_array(response_ids)
      expect(employments_ids.count).to eq(last_response_body.people.count)
    end
  end

end
