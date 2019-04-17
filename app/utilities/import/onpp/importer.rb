require 'nokogiri'
require 'utilities/import/onpp/person_collection'
require 'utilities/import/onpp/node_collection'
require 'utilities/import/onpp/unit_collection'
require 'utilities/import/onpp/employment_collection'
require 'yaml'

module Utilities
  module Import
    module ONPP
      class Importer

        def initialize
          @people      = Utilities::Import::ONPP::PersonCollection.new
          @nodes       = Utilities::Import::ONPP::NodeCollection.new
          @units       = Utilities::Import::ONPP::UnitCollection.new
          @employments = Utilities::Import::ONPP::EmploymentCollection.new
          @contacts    =  Utilities::Import::ONPP::ExternalContactCollection.new
        end


        def import(language:)

          blacklist_xml_str = IO.read ENV['STAFF_IMPORT_BLACKLIST_FILE_PATH']
          blacklist_doc = ::Nokogiri::XML(blacklist_xml_str, nil, 'UTF-8')

          @nodes.import_black_list(blacklist_doc)
          @employments.import_black_list(blacklist_doc)

          xml_str = IO.read ENV['STAFF_IMPORT_FILE_PATH']
          doc = ::Nokogiri::XML(xml_str, nil, 'CP1251')

          @nodes.import_from_xml(doc)
          @employments.import(doc, @nodes)
          @people.import(doc, @nodes)

          yaml_str = YAML.load_file ENV['STAFF_IMPORT_EXTERNAL_CONTACTS_FILE_PATH']

          @nodes.import_from_yaml(yaml_str)

          @contacts.import(yaml_str)

          host = ENV['STAFF_IMPORT_LDAP_HOST']
          base = ENV['STAFF_IMPORT_LDAP_USERS_PATH']
          user_name = ENV['STAFF_IMPORT_LDAP_USER']
          user_password = ENV['STAFF_IMPORT_LDAP_PASSWORD']
          id_ldap_attribute = ENV['STAFF_IMPORT_LDAP_USER_ID_ATTRIBUTE']
          @people.import_emails(host, base, user_name, user_password, id_ldap_attribute)

          @people.delete_without_employment(@employments)

          @nodes.build_structure
          @nodes.get_structure_unit(@employments)

          yaml_replace_list = YAML.load_file ENV['STAFF_IMPORT_REPLACEMENT_RULES']
          replace_list = Utilities::Import::ReplaceList.new
          replace_list.import(yaml_replace_list)
          replace_list.replace(@employments)

          # TODO a time to modify the structure
          @employments.link_data_to_people(@people)
          @people.cleanup_excess_employments(@employments)
          @employments.link_data_to_nodes(@nodes)
          @contacts.link_data_to_nodes(@nodes)

          @nodes.change_company_management(@employments)
          @nodes.reset_employments_link
          @employments.link_data_to_nodes(@nodes)

          @nodes.change_management_node(@employments)
          @nodes.reset_employments_link
          @employments.link_data_to_nodes(@nodes)

          @nodes.delete_empty_nodes
          # structure modified

          @nodes.reset_structure
          @nodes.build_structure

          @nodes.sort_child_nodes
          @nodes.sort_employments(@employments)

          @units.import_from_nodes(@nodes)

          @nodes.set_heads(@employments, @units)

          # then, let's read-write db
          @people.fetch_from_db
          @nodes.fetch_from_db
          @units.fetch_from_db
          @employments.fetch_from_db
          @contacts.fetch_from_db

          @people.drop_stale_objects
          @nodes.drop_stale_objects
          @units.drop_stale_objects
          @employments.drop_stale_objects
          @contacts.drop_stale_objects

          @people.build_new_objects
          @nodes.build_new_objects
          @units.build_new_objects
          @employments.build_new_objects
          @contacts.build_new_objects

          @people.import_photos
          @contacts.import_photos

          # link the objects using external ids
          @employments.link_node_objects(@nodes)
          @contacts.link_node_objects(@nodes)
          @units.link_node_objects(@nodes)
          @units.link_employment_objects(@employments)

          @nodes.link_node_objects
          @nodes.link_employment_objects(@employments)
          @nodes.link_contact_objects(@contacts)
          @nodes.link_unit_objects(@units)

          @people.link_employments(@employments)
          @employments.link_objects_to_people(@people)

          @people.flush_to_db
          @nodes.flush_to_db
          @units.flush_to_db
          @employments.flush_to_db
          @contacts.flush_to_db
        end

      end
    end
  end
end
