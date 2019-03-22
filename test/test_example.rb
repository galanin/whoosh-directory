require 'test_helper'
# doc https://ruby-doc.org/stdlib-1.9.3/libdoc/minitest/spec/rdoc/MiniTest/Spec.html
# bundle exec ruby -Itest test/test_example.rb

describe Staff::API do
  include Rack::Test::Methods

  let(:app) { Staff::API }
  let(:employment) { Employment.all.sample  }
  let(:token) { UserSession.all.sample.token  }

  it "test_to_call" do
    base_urn = "/api/user_information/to_call"
    params_urn = "?session_token=#{token}"

    # create to_call
    call_urn = base_urn + "/employment/#{employment.short_id}" + params_urn
    post call_urn
    expect(last_response.status).must_equal 201

    json = JSON.parse(last_response.body)
    json["to_call"]["employment_id"].must_equal employment.short_id
    to_call_id = json["to_call"]["id"]
    json["unchecked"].must_include to_call_id
    p "Create"
    pp json


    # get to_call list
    get_urn = base_urn + params_urn
    get get_urn
    expect(last_response.status).must_equal 200


    json = JSON.parse(last_response.body)
    json["employments"].must_include employment.as_json
    json["unchecked"].must_include to_call_id
    puts
    p "ToCall list"
    pp json

    # uncheck to_call
    uncheck_urn = base_urn + "/employment/#{employment.short_id}/check" + params_urn
    post uncheck_urn
    expect(last_response.status).must_equal 201

    json = JSON.parse(last_response.body)
    json["checked_today"].must_include to_call_id
    puts
    p "Uncheck ToCall list"
    pp json


    # delete to_call
    delete_urn = base_urn + "/employment/#{employment.short_id}" + params_urn
    delete delete_urn
    expect(last_response.status).must_equal 200

    json = JSON.parse(last_response.body)
    json["unchecked"].wont_include to_call_id
    json["checked_today"].wont_include to_call_id
    puts
    p "Delete ToCall"
    pp json

  end

end
