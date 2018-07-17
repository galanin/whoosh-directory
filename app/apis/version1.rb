module Staff
  class API < Grape::API

    format :json
    prefix :api


    get :bootstrap do
      units    = OrganizationUnit.only(:id, :level, :path, :list_title, :child_ids).index_by(&:id)
      expanded = units.select { |_, unit| unit.level < 2 }.map(&:second).map(&:id).map { |id| [id, 1] }.to_h
      {
          organization_units: units,
          expanded_units:     expanded,
      }
    end

  end
end
