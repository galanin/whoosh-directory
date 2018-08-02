module Staff
  class API < Grape::API

    format :json
    prefix :api

    before do
      header 'Access-Control-Allow-Origin', '*'
    end


    get :bootstrap do
      units    = OrganizationUnit.only(:id, :level, :path, :list_title, :child_ids).index_by(&:id)
      expanded = units.select { |_, unit| unit.level < 2 }.map(&:second).map(&:id).map { |id| [id, 1] }.to_h
      {
          organization_units: units,
          expanded_units:     expanded,
      }
    end


    get 'units/:unit_id' do
      if params.key? :unit_id
        unit = OrganizationUnit.only(:long_title, :short_title, :employment_ids).find(params[:unit_id])
        employments = unit.employment_ids.present? ? Employment.find(unit.employment_ids) : []
        people = Person.find(employments.map(&:person_id))
        {
          unit_info:   unit,
          employments: employments.index_by(&:id),
          people:      people.index_by(&:id),
        }
      end
    end

  end
end
