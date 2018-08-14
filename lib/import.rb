require 'active_support/core_ext/module/delegation'

class Import

  class Cache

    attr_reader :cache, :index_by_id
    delegate :each, :select, to: :cache
    delegate :[], to: :index_by_id


    def initialize(entity_class)
      @entity_class = entity_class
      @cache = entity_class.all.to_a
      @index_by_id = @cache.index_by(&:id)
    end


    def import(field_values)
      entity_id  = field_values[:id]
      entity = index_by_id[entity_id]
      if entity.present?
        entity.write_attributes(field_values)
      else
        entity = create(field_values)
      end
      entity.imported!
      entity
    end


    def create(field_values)
      new_entity = @entity_class.new(field_values)
      @cache << new_entity
      @index_by_id[new_entity.id] = new_entity
      new_entity
    end

  end


  attr_reader :unit_cache, :person_cache, :employment_cache


  def initialize
    @unit_cache = Cache.new(OrganizationUnit)
    @person_cache = Cache.new(Person)
    @employment_cache = Cache.new(Employment)
  end


  def build_structure
    cleanup_outdated_child_units
    cleanup_outdated_employments

    unit_cache.each do |unit|
      next unless unit.parent_id.present?
      parent = unit_cache[unit.parent_id]
      parent.child_ids ||= []
      parent.child_ids << unit.id
    end

    unit_cache.each { |unit| unit.level = nil }
    unit_cache.each { |unit| count_unit_level(unit); }

    employment_cache.each do |employment|
      person = person_cache[employment.person_id]
      person.employment_ids ||= []
      person.employment_ids << employment.id
      unit = unit_cache[employment.unit_id]
      unit.employment_ids ||= []
      unit.employment_ids << employment.id
    end

    unit_cache.each do |unit|
      if unit.child_ids.present?
        unit.child_ids.uniq!
        unit.child_ids.sort_by! { |child_id| unit_cache[child_id].path }
      end
      if unit.employment_ids.present?
        unit.employment_ids.uniq!
        # TODO sort people in unit
      end
    end

    person_cache.each do |person|
      if person.employment_ids.present?
        person.employment_ids.uniq!
      end
    end
  end


  def cleanup_outdated_child_units
    unit_cache.each do |unit|
      if unit.child_ids.present?
        unit.child_ids.reject! { |child_id| unit_cache[child_id].nil? }
      end
    end
  end


  def cleanup_outdated_employments
    unit_cache.each do |unit|
      if unit.employment_ids.present?
        unit.employment_ids.reject! { |employment_id| employment_cache[employment_id].nil? }
      end
    end
  end


  def count_unit_level(unit)
    unit.level ||= if unit.parent_id.blank?
      0
    else
      count_unit_level(unit_cache[unit.parent_id]) + 1
    end
  end


  def save
    build_structure

    unit_cache.cache.select(&:imported?).select(&:changed?).each(&:save)
    person_cache.cache.select(&:imported?).select(&:changed?).each(&:save)
    employment_cache.cache.select(&:imported?).select(&:changed?).each(&:save)
  end


  def cleanup
    unit_cache.cache.select(&:expired?).each(&:destroy)
    person_cache.cache.select(&:expired?).each(&:destroy)
    employment_cache.cache.select(&:expired?).each(&:destroy)
  end

end
