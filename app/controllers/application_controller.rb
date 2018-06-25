class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def app
    units = OrganizationUnit.all.index_by(&:id)
    expanded = units.select { |_, unit| unit.level < 2 }.map(&:second).map(&:id)
    props = {
        organization_units: units.as_json,
        expanded_units: expanded,
    }
    render component: 'App', props: props, prerender: false
  end

end
