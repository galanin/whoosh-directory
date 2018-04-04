class Import

  def unit_cache
    @unit_cache ||= OrganizationUnit.all.to_a
  end


  def unit_index_by_id
    @existing_units_index_by_id ||= unit_cache.index_by(&:id)
  end


  def person_cache
    @person_cache ||= Person.all.to_a
  end


  def person_index_by_id
    @existing_person_index_by_id ||= person_cache.index_by(&:id)
  end


  def employment_cache
    @employment_cache ||= Employment.all.to_a
  end


  def employment_index_by_id
    @existing_employment_index_by_id ||= person_cache.index_by(&:id)
  end


  def build_structure
    unit_cache.each do |unit|
      unit.parent = unit_index_by_id[unit.parent_id]
    end
    employment_cache.each do |employment|
      employment.person = person_index_by_id[employment.person_id]
      employment.unit   = unit_index_by_id[employment.unit_id]
      employment.dept   = unit_index_by_id[employment.dept_id]
    end
  end


  def create_unit(field_values)
    new_unit = OrganizationUnit.new(field_values)
    unit_cache << new_unit
    unit_index_by_id[new_unit.id] = new_unit
    new_unit
  end


  def create_person(field_values)
    new_person = Person.new(field_values)
    person_cache << new_person
    person_index_by_id[new_person.id] = new_person
    new_person
  end


  def create_employment(field_values)
    new_employment = Employment.new(field_values)
    employment_cache << new_employment
    employment_index_by_id[new_employment.id] = new_employment
    new_employment
  end


  def save
    puts 'PERSON'
    person_cache.select(&:imported?).select(&:invalid?).select(&:changed?).each { |e| p e }
    puts 'EMPLOYMENT'
    employment_cache.select(&:imported?).select(&:changed?).each { |e| p e.uuid, e.person_uuid, e.changes, e.valid? }
    puts 'UNIT'
    unit_cache.select(&:imported?).select(&:valid?).select(&:changed?).each { |u| p u.uuid, u.changes }

    unit_cache.select(&:imported?).select(&:changed?).each(&:save)
    person_cache.select(&:imported?).select(&:changed?).each(&:save)
    employment_cache.select(&:imported?).select(&:changed?).each(&:save)
  end


  def cleanup
    unit_cache.select(&:expired?).each(&:destroy)
    person_cache.select(&:expired?).each(&:destroy)
    employment_cache.select(&:expired?).each(&:destroy)
  end

end
