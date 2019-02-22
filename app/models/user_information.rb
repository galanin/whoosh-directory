class UserInformation < ApplicationRecord
  include Mongoid::Document
  include Mongoid::Timestamps

  field :expanded_units, type: Array, default: -> { Unit.where(:level.lt => 2, :destroyed_at => nil).pluck(:short_id).compact }

  has_many :user_session
  has_many :to_call, autosave: true
  has_many :histories, autosave: true
  embeds_many :favorite_person, cascade_callbacks: true
  embeds_many :favorite_unit, cascade_callbacks: true


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


  def get_checked_to_call_history(year, month, day)
  end


  def to_call_checked_today_ids
    to_call.checked_today.sort_checked.pluck(:short_id)
  end


  def to_call_unchecked_ids
    to_call.unchecked.pluck(:short_id)
  end


  def create_favorite_unit(unit_short_id)
    favorite_unit_entity = find_favorite_unit(unit_short_id)
    unless favorite_unit_entity.present?
      unit = Unit.find_by(short_id: unit_short_id)
      favorite_unit_entity = favorite_unit.create(unit: unit, unit_short_id: unit.short_id, alpha_sort: unit.alpha_sort)
      sort_favorite_unit
      favorite_unit_entity
    end
  end


  def sort_favorite_unit
    self.favorite_unit  = self.favorite_unit.sort_by{|x| x.alpha_sort}
  end


  def find_favorite_unit(unit_short_id)
    favorite_unit.where(unit_short_id: unit_short_id).first if unit_short_id.present?
  end


  private :find_favorite_unit, :sort_favorite_unit


  def destroy_favorite_unit(unit_short_id)
    favorite_unit_entity = favorite_unit.find_by(unit_short_id: unit_short_id)
    favorite_unit_entity.delete
  end


  def create_favorite_person(entity_type, entity_short_id)
    favorite_entity = find_favorite_person_by_entity(entity_type, entity_short_id)
    unless favorite_entity.present?
      entity = entity_type.camelize.constantize.find_by(short_id: entity_short_id)
      favorite_person_entity = favorite_person.create(favoritable: entity, favorable_short_id: entity_short_id, alpha_sort: entity.alpha_sort)
      sort_favorite_person
      favorite_person_entity
    end
  end


  def destroy_favorite_person(entity_type, entity_short_id)
    favorite_entity = favorite_person.find_by(favorable_short_id: entity_short_id, favoritable_type: entity_type.camelize)
    favorite_entity.delete
  end


  def sort_favorite_person
    self.favorite_person = self.favorite_person.sort_by{|x| x.alpha_sort}
  end


  def find_favorite_person_by_entity(entity_type, entity_short_id)
    favorite_person.where(favorable_short_id: entity_short_id, favoritable_type: entity_type.camelize).first if entity_short_id.present?
  end


  private :find_favorite_person_by_entity, :sort_favorite_person


  def destroy_history(short_id)
    history_person_entity = histories.find_by(short_id: short_id)
    history_person_entity.delete
  end


  def get_histories_by_date(begin_date_string, end_date_string)
    begin_date = Date.strptime(begin_date_string, "%Y-%m-%d")
    end_date = end_date_string.nil? ? begin_date : Date.strptime(end_date_string, "%Y-%m-%d")
    histories.where(updated_at: begin_date.beginning_of_day..end_date.end_of_day).sort_updated
  end


  def create_or_update_history_person(employment_short_id)
    history_person_entity = find_history_person(employment_short_id)
    if history_person_entity.present?
      history_person_entity.touch(:updated_at)
    else
      employment = Employment.find_by(short_id: employment_short_id)
      history_person_entity = HistoryPerson.create(user_information: self, employment: employment, employment_short_id: employment_short_id)
    end
    history_person_entity
  end


  def find_history_person(employment_short_id)
    histories.created_today.person.where(employment_short_id: employment_short_id).first
  end


  private :find_history_person


  def create_or_update_history_unit(unit_short_id)
    history_unit_entity = find_history_unit(unit_short_id)
    if history_unit_entity.present?
      history_unit_entity.touch(:updated_at)
    else
      unit = Unit.find_by(short_id: unit_short_id)
      history_unit_entity = HistoryUnit.create(user_information: self, unit: unit, unit_short_id: unit_short_id)
    end
    history_unit_entity
  end


  def find_history_unit(unit_short_id)
    histories.created_today.unit.where(unit_short_id: unit_short_id).first
  end


  private :find_history_unit


  def create_or_update_history_search(search_string)
    history_search_entity = find_history_search(search_string)
    if history_search_entity.present?
      history_search_entity.touch(:updated_at)
    else
      history_search_entity = HistorySearch.create(user_information: self, search_string: search_string)
    end
    history_search_entity
  end


  def find_history_search(search_string)
    histories.created_today.search.where(search_string: search_string).first
  end


  private :find_history_search


end
