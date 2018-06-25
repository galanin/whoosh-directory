class OrganizationUnit < ApplicationRecord
  include Mongoid::Document
  include Mongoid::Timestamps
  include ImportEntity

  field :_id,            type: String
  field :title,          type: String
  field :short,          type: String
  field :path,           type: String
  field :child_ids,      type: Array
  field :employment_ids, type: Array
  field :level,          type: Integer

  has_many   :children, inverse_of: :parent, class_name: 'OrganizationUnit', order: :path.asc
  belongs_to :parent, inverse_of: :children, class_name: 'OrganizationUnit', optional: true

  has_many :unit_employments, inverse_of: :unit, class_name: 'Employment'
  has_many :dept_employments, inverse_of: :dept, class_name: 'Employment'


  def as_json(options = nil)
    {
        id:             id.to_s,
        title:          title,
        short:          short,
        parent_id:      parent_id.to_s,
        path:           path,
        level:          level,
        child_ids:      child_ids,
        employment_ids: employment_ids,
    }
  end

end
