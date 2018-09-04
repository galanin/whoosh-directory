class Employment < ApplicationRecord
  include Mongoid::Document
  include Mongoid::Timestamps
  include ImportEntity

  field :_id,               type: String
  field :post,              type: String
  field :number,            type: Integer
  field :category,          type: String
  field :office,            type: String
  field :building,          type: String
  field :phones,            type: Array
  field :lunch_begin,       type: Time
  field :lunch_end,         type: Time
  field :parental_leave,    type: Boolean
  field :vacation,          type: Boolean
  field :vacation_begin,    type: Date
  field :vacation_end,      type: Date
  field :working_type,      type: String
  field :working_type_prio, type: Integer

  belongs_to :person
  belongs_to :unit, inverse_of: :unit_employments, class_name: 'OrganizationUnit'
  belongs_to :dept, inverse_of: :dept_employments, class_name: 'OrganizationUnit'


  def as_json(options = nil)
    super.except('_id').merge('id' => id)
  end

end
