Dir[File.join(__dir__, 'modules', '*.rb')].each { |file| require_relative file }

module Staff
  class API < Grape::API

    rescue_from Mongoid::Errors::DocumentNotFound do |e|
      error!(e, 404)
    end


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

    mount Staff::BirthdayAPI
    mount Staff::EmploymentAPI
    mount Staff::FavoriteAPI
    mount Staff::HistoryAPI
    mount Staff::SessionAPI
    mount Staff::SearchAPI
    mount Staff::ToCallAPI
    mount Staff::UnitAPI
    mount Staff::UserInformationAPI

  end
end
