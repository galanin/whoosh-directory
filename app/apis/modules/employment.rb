module Staff
  class EmploymentAPI < Grape::API

    params {
      requires :who, type: String
    }

    get 'employments/:who' do
      employ_ids = params[:who].split(',')

      employments = Employment.where(destroyed_at: nil).in(short_id: employ_ids)
      present :employments, employments

      people = Person.in(short_id: employments.map(&:person_short_id))
      present :people, people
    end

  end
end
