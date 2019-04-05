require 'spec_helper'

describe Staff::API do
  include Rack::Test::Methods

  before do
    create_structure
    Utilities::Import::SearchIndex.rebuild
  end

  let (:app) { Staff::API }

  def request_and_tests(query, entity)
    get "/api/search?q=#{query}"
    response_ids = get_ids(last_response_body.results, "#{entity.class.name.downcase}_id")

    expect(last_response).to has_status_200
    expect(response_ids).to include(entity.short_id)
  end

  context 'check search api' do

    it 'find person by last_name' do
      person = Person.all.sample
      query = create_query(person.last_name)
      request_and_tests(query, person)
    end


    it 'find person by phone' do
      person = Person.all.sample
      phone_str = person.employments.first.telephones.phone_w_type['local'].first
      length = phone_str.length
      start_number = Random.rand(4..(length-4))
      query = phone_str[start_number...length]
      request_and_tests(query, person)
    end


    it 'find person by post' do
      person = Person.all.sample
      query = create_query(person.employments.first.post_title)
      request_and_tests(query, person)
    end


    it 'find person by building' do
      person = Person.all.sample
      query = person.employments.first.building
      request_and_tests(query, person)
    end


    it 'find person by office' do
      person = Person.all.sample
      query = person.employments.first.office
      request_and_tests(query, person)
    end


    it 'find person by birthday' do
      person = Person.all.sample
      query = Date.strptime(person.birthday, '%m-%d').strftime(I18n.t('birthday.search_format'))

      get "/api/search?q=#{query}"
      people_ids = get_ids(last_response_body.birthdays.first['results'], 'person_id')

      expect(last_response).to has_status_200
      expect(people_ids).to include(person.short_id)
    end


    it 'find unit by title' do
      unit = Unit.all.sample
      query = create_query(unit.long_title)
      request_and_tests(query, unit)
    end

  end
end
