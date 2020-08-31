require 'mongoid/tree'

class Node < ApplicationRecord
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Tree
  include Mongoid::Paranoia
  include ShortId
  include Importable
  include ImportableNode

  field :title,           type: String
  field :node_type,       type: String # one of [org, dir, div, vice, man, dep, sec,  nil]
  field :parent_short_id, type: String
  field :child_short_ids, type: Array
  field :employment_short_id, type: String
  field :unit_short_id,   type: String
  field :employ_ids,      type: Array
  field :contact_ids,     type: Array
  field :default_expanded,type: Boolean
  field :root_sort,       type: String

  belongs_to :employment, optional: true
  belongs_to :unit, optional: true
  has_many :child_employments, class_name: 'Employment', inverse_of: :parent_node
  has_many :child_contacts, class_name: 'ExternalContact', inverse_of: :parent_node


  scope :tree_fields, -> { only(:short_id, :title, :variant, :child_short_ids) }
  scope :info_fields, -> { only(:short_id, :employment_short_id, :unit_short_id, :employ_ids, :contact_ids) }
  scope :root_fields, -> { only(:child_short_ids) }
  scope :with_children, ->(node_ids) { all.or({:short_id.in => node_ids}, {:parent_short_id.in => node_ids}) }


  index({ destroyed_at: 1, short_id: 1 })
  index({ destroyed_at: 1, parent_short_id: 1 })


  def as_json(options = nil)
    json = {
      'id' => short_id,
    }
    json['t'] = title if has_attribute?(:title)
    json['y'] = type if has_attribute?(:variant)
    json['c'] = child_short_ids if has_attribute?(:child_short_ids) and child_short_ids.present?
    json['employment_id'] = employment_short_id if has_attribute?(:employment_short_id)
    json['unit_id'] = unit_short_id if has_attribute?(:unit_short_id)
    json['employ_ids'] = employ_ids if has_attribute?(:employ_ids) and employ_ids.present?
    json['contact_ids'] = contact_ids if has_attribute?(:contact_ids) and contact_ids.present?

    json
  end


  def self.employments
    Employment.where(destroyed_at: nil).in(short_id: all.map(&:employment_short_id).compact)
  end


  def self.child_employments
    Employment.where(destroyed_at: nil).in(short_id: all.map(&:employ_ids).compact.flatten)
  end


  def self.child_contacts
    ExternalContact.where(destroyed_at: nil).in(short_id: all.map(&:contact_ids).compact.flatten)
  end


  def self.units
    Unit.where(destroyed_at: nil).in(short_id: all.map(&:unit_short_id).compact)
  end


  def root_ids
    Unit.where(destroyed_at: nil, parent_short_id: nil).pluck(:short_id)
  end

end
