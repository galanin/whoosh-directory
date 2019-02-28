require 'nokogiri'
require 'utilities/import/onpp/person_collection'
require 'utilities/import/onpp/unit_collection'
require 'utilities/import/onpp/employment_collection'
require 'yaml'

module Utilities
  module Import
    module ONPP
      class Importer

        def initialize
          @people = Utilities::Import::ONPP::PersonCollection.new(::Person)
          @units = Utilities::Import::ONPP::UnitCollection.new(::Unit)
          @employments = Utilities::Import::ONPP::EmploymentCollection.new(::Employment)
          @external_contact =  Utilities::Import::ONPP::ExternalContactCollection.new(::ExternalContact)
        end


        def import

          blacklist_xml_str = IO.read ENV['STAFF_IMPORT_BLACKLIST_FILE_PATH']
          blacklist_doc = ::Nokogiri::XML(blacklist_xml_str, nil, 'UTF-8')

          @units.import_black_list(blacklist_doc)
          @employments.import_black_list(blacklist_doc)

          xml_str = IO.read ENV['STAFF_IMPORT_FILE_PATH']
          doc = ::Nokogiri::XML(xml_str, nil, 'CP1251')

          @units.import_from_xml(doc)
          @employments.import(doc, @units)
          @people.import(doc, @units)

          yaml_str = YAML.load_file ENV['STAFF_IMPORT_EXTERNAL_CONTACTS_FILE_PATH']

          @units.import_from_yaml(yaml_str)
          @external_contact.import(yaml_str)

          host = ENV['STAFF_IMPORT_LDAP_HOST']
          base = ENV['STAFF_IMPORT_LDAP_USERS_PATH']
          user_name = ENV['STAFF_IMPORT_LDAP_USER']
          user_password = ENV['STAFF_IMPORT_LDAP_PASSWORD']
          id_ldap_attribute = ENV['STAFF_IMPORT_LDAP_USER_ID_ATTRIBUTE']
          @people.import_emails(host, base, user_name, user_password, id_ldap_attribute)

          @people.delete_without_employment(@employments)

          @units.build_structure

          yaml_replace_list = YAML.load_file ENV['STAFF_IMPORT_REPLACEMENT_RULES']
          replace_list = Utilities::Import::ReplaceList.new
          replace_list.import(yaml_replace_list)
          replace_list.replace(@employments)

          @employments.link_data_to_people(@people)
          @people.cleanup_excess_employments(@employments)
          @people.reset_employments_link

          @employments.link_data_to_people(@people)
          @employments.link_data_to_units(@units)
          @external_contact.link_data_to_units(@units)

          @units.change_company_managment(@employments)
          @units.reset_employments_link
          @employments.link_data_to_units(@units)

          @units.change_management_unit(@employments)
          @units.reset_employments_link
          @employments.link_data_to_units(@units)

          @units.delete_empty_units

          # TODO a time to modify the structure
          @units.reset_structure
          @units.build_structure

          @units.sort_child_units
          @units.calc_levels
          @units.sort_employments(@employments)
          @units.set_bosses(@employments)

          @people.fetch_from_db
          @units.fetch_from_db
          @employments.fetch_from_db
          @external_contact.fetch_from_db

          @people.drop_stale_objects
          @units.drop_stale_objects
          @employments.drop_stale_objects
          @external_contact.drop_stale_objects

          @people.build_new_objects
          @units.build_new_objects
          @employments.build_new_objects
          @external_contact.build_new_objects

          @people.import_photos
          @external_contact.import_photos

          @units.link_objects_to_children_short_ids
          @units.link_objects_to_employment_short_ids(@employments)
          @units.link_objects_to_contact_short_ids(@external_contact)
          @people.link_objects_to_employment_short_ids(@employments)
          @employments.link_objects_to_people(@people)
          @employments.link_objects_to_units(@units)
          @external_contact.link_objects_to_units(@units)

          @people.flush_to_db
          @units.flush_to_db
          @employments.flush_to_db
          @external_contact.flush_to_db
        end

      end
    end
  end
end
