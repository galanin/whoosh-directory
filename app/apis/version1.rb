require_relative './modules/birthday.rb'
require_relative './modules/employment.rb'
require_relative './modules/session.rb'
require_relative './modules/search.rb'
require_relative './modules/unit.rb'
require_relative './modules/user_information.rb'

module Staff
  class API < Grape::API

    rescue_from Mongoid::Errors::DocumentNotFound do |e|
      error!(e, 404)
    end


    version VERSION, using: :header, vendor: 'whoosh-directory', cascade: false #application/vnd.whoosh-directory-v1+json
    format :json
    prefix :api
    helpers FetchingHelpers, BirthdayHelpers, ToCallHelpers


    before do
      header 'Access-Control-Allow-Origin', '*'
    end


    options '*' do
      header 'Access-Control-Allow-Methods', 'OPTIONS, GET, POST, PUT, DELETE'
      header 'Access-Control-Allow-Headers', 'Content-Type'
    end

    get 'check_version' do
      {}
    end


    mount Staff::BirthdayAPI
    mount Staff::EmploymentAPI
    mount Staff::SessionAPI
    mount Staff::SearchAPI
    mount Staff::UnitAPI
    mount Staff::UserInformationAPI

  end
end
