require 'spec_helper'

describe Staff::API do
  include Rack::Test::Methods

  before do
    create_structure
  end

  let (:app) { Staff::API }

  context 'check units api' do

    it 'api/units' do
      get 'api/units'
      expect(last_response).to has_status_200
      expect(last_response_body.units.count).to eq(Unit.where(destroyed_at: nil).count)
    end


    it 'units/:unit_id' do
      unit = Unit.all.sample

      get "api/units/#{unit.short_id}"

      expect(last_response).to has_status_200
      expect(last_response_body.units.first['long_title']).to eq unit.long_title
      expect(last_response_body.units.first['id']).to eq unit.short_id

      employment_response_ids = get_ids(last_response_body.employments, 'id')
      expect(employment_response_ids).to match_array(unit.employ_ids)
      expect(last_response_body.people.count).to eq unit.employ_ids.count
    end

  end

end
