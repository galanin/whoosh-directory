require 'utilities/import/collection'

module Utilities
  module Import
    module ONPP
      class ExternalContactCollection

        include Utilities::Import::Collection


        def import(source_data)
          source_data.each do |unit|
            unit_id = unit["id"]
            unit["contacts"].each do |contact|
              new_data = Utilities::Import::ONPP::ExternalContact.new(contact, unit_id)
              add_new_data(new_data)
            end
          end
        end


        def import_photos
          @entities.each do |id, external_contact_entity|
            unless external_contact_entity.stale?
              import_contact_photo(id, external_contact_entity.old_object)
            end
          end
        end


        def import_contact_photo(external_id, contact)
          photo_path = File.join(ENV['STAFF_IMPORT_PHOTO_PATH'], "#{external_id}.jpg")
          # puts photo_path
          if File.exists?(photo_path)
            photo_modified_time = File.mtime(photo_path)
            if contact.photo_updated_at.nil? || photo_modified_time > contact.photo_updated_at
              # puts ' do import'
              File.open(photo_path) do |f|
                contact.photo = f
                contact.photo_updated_at = Time.now
                # puts '  success'
              end
            else
              # puts ' ignore'
            end
          end
        end


        def link_data_to_units(unit_collection)
          @entities.each do |id, external_contact_entity|
            unit_entity = unit_collection[ external_contact_entity.new_data.unit_external_id.to_s ]
            unit_entity.new_data.contact_ids = [] if unit_entity.new_data.contact_ids.nil?
            unit_entity.new_data.contact_ids << id
          end
        end


        def link_objects_to_units(unit_collection)
          @entities.each do |id, external_contact_entity|
            if external_contact_entity.new_data.present?
              unit_entity = unit_collection[ external_contact_entity.new_data.unit_external_id.to_s ]
              external_contact_entity.old_object.unit = unit_entity.old_object
              external_contact_entity.old_object.unit_short_id = unit_entity.old_object.short_id
            end
          end
        end

      end
    end
  end
end
