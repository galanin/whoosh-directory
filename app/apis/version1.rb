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

    helpers do

      def set_cache_header(time_in_seconds=0)
        unless time_in_seconds.nil? || time_in_seconds == 0
          header 'Cache-Control', "private, max-age=#{time_in_seconds}"
          header 'Expires', CGI.rfc1123_date(Time.now.utc + time_in_seconds)
        else
          header 'Cache-Control', 'no-cache'
        end
      end

    end


    options '*' do
      header 'Access-Control-Allow-Methods', 'OPTIONS, GET, POST, PUT, DELETE'
      header 'Access-Control-Allow-Headers', 'Content-Type'
    end


    get 'check_version' do
      {}
    end


    mount Staff::NodesAPI
    mount Staff::BirthdayAPI
    mount Staff::EmploymentAPI
    mount Staff::SessionAPI
    mount Staff::SearchAPI
    mount Staff::UnitAPI
    mount Staff::UserInformationAPI

  end
end
