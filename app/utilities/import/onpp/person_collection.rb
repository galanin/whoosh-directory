require 'utilities/import/collection'

module Utilities
  module Import
    module ONPP
      class PersonCollection

        include Utilities::Import::Collection


        def import(doc)
          doc.xpath('.//person').each do |person|
            new_data = Utilities::Import::ONPP::Person.new(person)
            add_new_data(new_data)
          end
        end


        def cleanup_excess_employments(employment_collection)
          @entities.each do |id, person_entity|
            if person_entity.new_data.employment_ids.count > 1
              person_entity.new_data.employment_ids.sort_by! { |employment_id| employment_collection[employment_id].new_data.for_person_rank }
              person_entity.new_data.employment_ids[1..-1].each { |employment_id| employment_collection.remove_by_id(employment_id) }
            end
          end
        end


        def reset_employments_link
          @entities.each do |id, person_entity|
            person_entity.new_data.employment_ids = []
          end
        end


        def import_photos
          @entities.each do |id, person_entity|
            unless person_entity.stale?
              import_person_photo(id, person_entity.old_object)
            end
          end
        end


        def link_objects_to_employment_short_ids(employment_collection)
          @entities.each do |id, unit_entity|
            unit_entity.old_object.employ_ids = employment_collection.short_ids_by_external_ids(unit_entity.new_data.employment_ids)
          end
        end


        private


        def import_person_photo(external_id, person)
          photo_path = File.join(ENV['STAFF_IMPORT_PHOTO_PATH'], "#{external_id}.jpg")
          # puts photo_path
          if File.exists?(photo_path)
            photo_modified_time = File.mtime(photo_path)
            if person.photo_updated_at.nil? || photo_modified_time > person.photo_updated_at
              # puts ' do import'
              File.open(photo_path) do |f|
                person.photo = f
                person.photo_updated_at = Time.now
                # puts '  success'
              end
            else
              # puts ' ignore'
            end
          end
        end

      end
    end
  end
end
