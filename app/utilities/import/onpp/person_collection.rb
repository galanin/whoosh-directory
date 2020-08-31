require 'utilities/import/collection'
require 'utilities/import/onpp/person_entity'
require 'utilities/import/ldap_connection'

module Utilities
  module Import
    module ONPP
      class PersonCollection

        include Utilities::Import::Collection


        self.entity_class = Utilities::Import::ONPP::PersonEntity
        self.object_class = ::Person


        def import(doc, unit_collection)
          doc.xpath('.//person').each do |person|
            unless unit_collection.present_in_black_list?(person['ID_PODR'])
              new_data = Utilities::Import::ONPP::PersonData.new(person)
              add_new_data(new_data)
            end
          end
        end

        def delete_without_employment(employment_collection)
          @entities.keep_if { |id, person| employment_collection.person_has_employment?(id) }
        end


        def cleanup_excess_employments(employment_collection)
          @entities.each do |id, person_entity|
            person_entity.new_data.cleanup_excess_employments(employment_collection)
          end
        end


        def import_emails(emails)
          @entities.each do |id, person_entity|
            person_entity.new_data.email = emails[id]
          end
        end


        def import_photos
          @entities.each do |id, person_entity|
            unless person_entity.stale?
              import_person_photo(id, person_entity.old_object)
            end
          end
        end


        def link_employments(employment_collection)
          @entities.each do |id, person_entity|
            if person_entity.new_data
              person_entity.old_object.employ_ids = employment_collection.short_ids_by_external_ids(person_entity.new_data.employment_external_ids).presence
            end
          end
        end


        private


        def import_person_photo(external_id, person)
          photo_path = File.join(ENV['STAFF_IMPORT_PHOTO_PATH'], "#{external_id}.jpg")
          # puts photo_path
          if File.exists?(photo_path)
            photo_modified_time = File.mtime(photo_path)
            if person.is_photo_stale?(photo_modified_time) || ENV['STAFF_IMPORT_FORCE_PHOTO_UPDATE']
              # puts ' do import'
              File.open(photo_path) do |f|
                person.photo_file = f
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
