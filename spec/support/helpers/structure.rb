module StructureHelper

  STRUCTURE_RULES = {
                      'org' => {sub_item: %w(div dep), sub_number: 1..5, empl_number: 1..1},
                      'div' => {sub_item: %w(dep), sub_number: 1..5, empl_number: 1..1},
                      'dep' => {sub_item: %w(sec), sub_number: 0..5, empl_number: 1..20},
                      'sec' => {sub_item: [], sub_number: 0..0, empl_number: 1..20},
  }


  def create_structure
    organization = create_organization
    create_sub_unit(organization)
  end

  def create_organization
    organization = FactoryBot.create :org_unit
    director = FactoryBot.create :director, :with_person, unit: organization
    organization
  end


  def create_sub_unit(unit)
    unit_type = unit.type
    Random.rand(STRUCTURE_RULES[unit_type][:sub_number]).times do
      factory_type = STRUCTURE_RULES[unit_type][:sub_item].sample
      factory_name = "#{factory_type}_unit".to_sym
      sub_unit = FactoryBot.create factory_name , level: unit.level + 1
      add_people(sub_unit)
      unit.child_ids << sub_unit.short_id
      unit.save
      create_sub_unit(sub_unit)
      sub_unit
    end

  end

  def add_people(unit)
    unit_type = unit.type
    head = FactoryBot.create :manager, :with_person, unit: unit, unit_callback: true
    employment_number = Random.rand(STRUCTURE_RULES[unit_type][:empl_number]) - 1
    employment_number.times do
      FactoryBot.create :specialist, :with_person, unit: unit, unit_callback: true
    end
    unit.save
  end

end
