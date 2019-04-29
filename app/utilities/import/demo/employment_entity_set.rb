require 'utilities/import/demo/entity_set'

module Utilities
  module Import
    module Demo
      class EmploymentEntitySet
        include EntitySet

        def generate_missing
          generate_missing_objects do |employment|
            new_person = generate_person(employment.external_id)
            employment.link_person(new_person)
            new_person.link_employment(employment)

            update_employment_fields(employment)
            # puts "EMPLOY IDS #{ employment.person.employ_ids }"
          end
        end


        def update_existing
          update_existing_objects do |employment|
            update_employment_fields(employment)
          end
        end


        def drop_excessive
          drop_excessive_objects do |employment|
            employment.person.drop
          end
        end


        def assign_head_id(node_collection)
          new_data.assign_head_id(node_collection)
        end


        def link_node_objects(node_collection)
          old_objects.each do |old_object|
            old_object.link_node(node_collection.object_by_external_id(new_data.node_external_id))
            old_object.link_parent_node(node_collection.object_by_external_id(new_data.parent_node_external_id))
          end
        end


        def update_employment_fields(employment)
          update_office(employment, new_data.office)
          update_alpha_sort(employment)
        end


        def update_office(employment, new_office)
          if random_office?(new_office)
            office_range = get_office_range(new_office)
            unless office_range.include?(employment.office.to_i)
              employment.office = rand(office_range).to_s
            end
          else
            employment.office = new_office
          end
        end


        def update_alpha_sort(employment)
          employment.alpha_sort = employment.person.sorting_title
        end


        def random_office?(office)
          office =~ /^\d+-\d+$/
        end


        def get_office_range(office)
          from, to = office.split('-').map(&:to_i)
          from .. to
        end



        def make_object_by_attributes(attributes)
          @object_class.new(attributes)
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
