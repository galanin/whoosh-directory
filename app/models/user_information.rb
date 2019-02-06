class UserInformation < ApplicationRecord
  include Mongoid::Document
  include Mongoid::Timestamps

  field :expanded_units, type: Array, default: -> { Unit.where(:level.lt => 2, :destroyed_at => nil).pluck(:short_id).compact }

  has_many :user_session
  embeds_many :to_call, cascade_callbacks: true
  embeds_many :favorite, cascade_callbacks: true


  def add_to_expanded_units(unit_ids)
    new_unit_ids = unit_ids - self.expanded_units

    if new_unit_ids.present?
      self.expanded_units += new_unit_ids
    end
  end


  def delete_from_expanded_unit(unit_id)
    if self.expanded_units.include?(unit_id)
      self.expanded_units.delete(unit_id)
    end
  end


  def create_to_call(employment_short_id)
    to_call_entity = find_to_call_by_employment(employment_short_id)
    if to_call_entity.present?
      to_call_entity.uncheck if to_call_entity.checked?
      to_call_entity
    else
      employment = Employment.find(employment_short_id)
      to_call.create(employment: employment, employment_short_id: employment_short_id)
    end
  end


  def check_to_call(employment_short_id)
    to_call_entity = find_to_call_by_employment(employment_short_id)
    to_call_entity.check unless to_call_entity.checked?
    to_call_entity
  end


  def destroy_to_call(employment_short_id)
    to_call_entity = find_to_call_by_employment(employment_short_id)
    to_call_entity.delete
  end


  def find_to_call(short_id)
    to_call.find_by(short_id: short_id)
  end


  def find_to_call_by_employment(employment_short_id)
    to_call.where(employment_short_id: employment_short_id).first if employment_short_id.present?
  end


  private :find_to_call, :find_to_call_by_employment


  def to_call_checked_ids
    to_call.checked.map(&:short_id)
  end

  def to_call_unchecked_ids
    to_call.unchecked.map(&:short_id)
  end


  def create_to_favorite(entity_name, entity_short_id)
    favorite_entity = find_favorite_by_entity(entity_short_id)
    if favorite_entity.empty?
      entity = entity_name.camelize.constantize.find(entity_short_id)
      favorite.create(favoritable: entity, favorable_short_id: entity_short_id)
    end
  end


  def destroy_favorite(entity_short_id)
    favorite_entity = find_favorite_by_entity(entity_short_id)
    if favorite_entity.present?
      favorite_entity.delete
    end
  end


  def find_favorite_by_entity(entity_short_id)
    favorite.where(favorable_short_id: entity_short_id).first if entity_short_id.present?
  end


end
