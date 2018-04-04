class Person < ApplicationRecord
  include Mongoid::Document
  include Mongoid::Timestamps
  include ImportEntity

  field :uuid,            type: String
  field :first_name,      type: String
  field :middle_name,     type: String
  field :last_name,       type: String
  field :birthday,        type: String
  field :hide_birthday,   type: Boolean
  field :gender,          type: String

  has_many   :employments

end
