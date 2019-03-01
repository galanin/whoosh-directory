require 'utilities/import/demo/entity_set'

module Utilities
  module Import
    module Demo
      class EmploymentEntitySet
        include EntitySet

        def generate_missing
          generate_missing_objects do |employment|
            employment.person = generate_person(employment.external_id)
            employment.person_short_id = employment.person.short_id
            employment.person.employments << employment
            employment.person.employ_ids ||= []
            employment.person.employ_ids << employment.short_id
          end
        end


        def drop_excessive
          drop_excessive_objects do |employment|
            employment.person.drop
          end
        end


        def link_node_objects(node_collection)
          old_objects.each do |old_object|
            old_object.node = node_collection.object_by_external_id(new_data.node_external_id)
            old_object.node_short_id = old_object.node&.short_id
            old_object.parent_node = node_collection.object_by_external_id(new_data.parent_node_external_id)
            old_object.parent_node_short_id = old_object.parent_node&.short_id
          end
        end


        def update_office(object, new_office)
          if random_office?
            office_range = get_office_range(new_office)
            unless office_range.include?(object.office.to_i)
              object.office = rand(office_range).to_s
            end
          else
            object.office = new_office
          end
        end


        def random_office?(office)
          office =~ /^\d+-\d+$/
        end


        def get_office_range(office)
          from, to = office.split('-').map(&:to_i)
          from..to
        end



        def make_object_by_attributes(attributes)
          new_object = @object_class.new(attributes)

        end


        private


        def generate_person(external_id)
          gender = rand > 0.5 ? 'F' : 'M'

          if gender == 'F'
            first_name = ::Faker::Name.female_first_name
            middle_name = ::Faker::Name.female_middle_name
            last_name = ::Faker::Name.female_last_name
          else
            first_name = ::Faker::Name.male_first_name
            middle_name = ::Faker::Name.male_middle_name
            last_name = ::Faker::Name.male_last_name
          end

          birthday = Date.today - rand(40 * 365)

          Person.create(
            external_id: external_id,
            gender:      gender,
            first_name:  first_name,
            middle_name: middle_name,
            last_name:   last_name,
            birthday:    birthday.strftime('%m-%d'),
          )
        end

      end
    end
  end
end
