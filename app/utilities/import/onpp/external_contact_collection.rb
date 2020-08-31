require 'utilities/import/collection'
require 'utilities/import/onpp/external_contact_entity'

module Utilities
  module Import
    module ONPP
      class ExternalContactCollection

        include Utilities::Import::Collection


        self.entity_class = Utilities::Import::ONPP::ExternalContactEntity
        self.object_class = ::ExternalContact


        def import(yaml_doc)
          yaml_doc.each do |node|
            node_id = node["id"].to_s
            node["contacts"].each do |contact|
              new_data = Utilities::Import::ONPP::ExternalContactData.new(contact, node_id)
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
            if contact.is_photo_stale?(File.mtime(photo_path))
              # puts ' do import'
              File.open(photo_path) do |f|
                contact.photo_file = f
                # puts '  success'
              end
            else
              # puts ' ignore'
            end
          end
        end


        def link_data_to_nodes(node_collection)
          @entities.each do |id, external_contact_entity|
            node_entity = node_collection[ external_contact_entity.new_data.parent_node_external_id.to_s ]
            node_entity.new_data.add_child_contact_data(external_contact_entity.new_data)
          end
        end


        def link_objects_to_units(unit_collection)
          @entities.each do |id, external_contact_entity|
            if external_contact_entity.new_data.present?
              unit_entity = unit_collection[ external_contact_entity.new_data.parent_node_external_id.to_s ]
              external_contact_entity.old_object.unit = unit_entity.old_object
              external_contact_entity.old_object.unit_short_id = unit_entity.old_object.short_id
            end
          end
        end


        def link_node_objects(node_collection)
          @entities.each do |id, entity|
            entity.link_node_objects(node_collection)
          end
        end

      end
    end
  end
end
