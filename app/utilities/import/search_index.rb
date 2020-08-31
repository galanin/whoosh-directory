module Utilities
  module Import
    class SearchIndex

      PRIORITY_FULL_TERM          = 100
      PRIORITY_LAST_NAME          = 6
      PRIORITY_EXTERNAL_CONTACT   = 6
      PRIORITY_FIRST_NAME         = 5
      PRIORITY_MIDDLE_NAME        = 4
      PRIORITY_UNIT_TITLE         = 3
      PRIORITY_POST_TITLE         = 2
      PRIORITY_LOWEST             = 1


      def self.rebuild
        search_index = Utilities::Import::SearchIndex.new

        Unit.where(destroyed_at: nil).each do |unit|
          search_index.add_object(unit)
        end
        Person.where(destroyed_at: nil).each do |person|
          search_index.add_object(person)
        end
        Employment.includes(:person).where(destroyed_at: nil).each do |employment|
          search_index.add_object(employment)
        end
        ExternalContact.where(destroyed_at: nil).each do |external_contact|
          search_index.add_object(external_contact)
        end

        search_index.update!
      end


      def initialize
        @entities = {}
      end


      def add_object(object)
        case object
        when Person then add_person(object)
        when Unit then add_unit(object)
        when Employment then add_employment(object)
        when ExternalContact then add_external_contact(object)
        end
      end


      def update!
        fetch_from_db
        drop_stale_entries
        build_new_entries
        flush_to_db
      end


      private


      def add_person(person)
        add_term(person.last_name, PRIORITY_LAST_NAME, person, partial: :begin)
        add_term(person.first_name, PRIORITY_FIRST_NAME, person, partial: :begin)
        add_term(person.middle_name, PRIORITY_MIDDLE_NAME, person, partial: :begin)
        add_normal_term(person.birthday, PRIORITY_LOWEST, person) if person.birthday
      end


      def add_unit(unit)
        # puts unit.long_title
        add_term(unit.long_title, PRIORITY_UNIT_TITLE, unit, partial: :begin)
        add_term(unit.short_title, PRIORITY_UNIT_TITLE, unit, partial: :begin)
        set_sub_order(unit.alpha_sort, unit)
      end


      def add_employment(employment)
        person = employment.person
        add_term(employment.post_title, PRIORITY_LOWEST, person, partial: :begin)
        if employment.office =~ /^(\d+)/
          add_term($~[1], PRIORITY_LOWEST, person)
        end
        add_term(employment.office, PRIORITY_LOWEST, person)
        add_term(employment.building, PRIORITY_LOWEST, person)
        set_sub_order(employment.alpha_sort, person)
        if employment.telephones.present?
          employment.telephones.phone_w_type.each do |phone_type, phone_array|
            phone_array.each do |phone|
              partial = (phone_type == "local" or phone_type == "mobile") ? :phone : :false
              add_term(phone, PRIORITY_LOWEST, person, partial: partial)
            end
          end
        end
      end


      def add_external_contact(external_contact)
        add_term(external_contact.last_name, PRIORITY_LAST_NAME, external_contact, partial: :begin)
        add_term(external_contact.first_name, PRIORITY_FIRST_NAME, external_contact, partial: :begin)
        add_term(external_contact.middle_name, PRIORITY_MIDDLE_NAME, external_contact, partial: :begin)
        add_normal_term(external_contact.birthday, PRIORITY_LOWEST, external_contact) if external_contact.birthday
        set_sub_order(external_contact.alpha_sort, external_contact)
        add_term(external_contact.function_title, PRIORITY_EXTERNAL_CONTACT, external_contact, partial: :begin)
        add_term(external_contact.location_title, PRIORITY_EXTERNAL_CONTACT, external_contact, partial: :begin)
        add_term(external_contact.post_title, PRIORITY_LOWEST, external_contact, partial: :begin)
        add_term(external_contact.office, PRIORITY_LOWEST, external_contact)
        add_term(external_contact.building, PRIORITY_LOWEST, external_contact)

        if external_contact.telephones.present?
          external_contact.telephones.phone_w_type.each do |phone_type, phone_array|
            phone_array.each do |phone|
              partial = (phone_type == "local" or phone_type == "mobile") ? :phone : :false
              add_term(phone, PRIORITY_LOWEST, external_contact, partial: partial)
            end
          end
        end
      end


      def fetch_from_db
        SearchEntry.where(destroyed_at: nil).each do |entry|
          add_entry(entry)
        end
      end


      def drop_stale_entries
        @entities.each do |id, entity|
          if entity.stale?
            entity.drop_stale_entry
            @entities.delete(id)
          end
        end
      end


      def build_new_entries
        @entities.each do |id, entity|
          entity.build_new_entry if entity.new?
        end
      end


      def flush_to_db
        @entities.each do |id, entity|
          entity.flush_to_db unless entity.stale?
        end
      end


      def add_entry(entry)
        entity = @entities[entry.searchable_id] ||= SearchEntity.new
        entity.search_entry = entry
      end


      def add_term(term, priority, object, options = {})
        if term.present?
          normalize_term(term).each do |normal_term|
            add_normal_term(normal_term, priority, object, options)
          end
        end
      end


      def add_normal_term(term, priority, object, options = {})
        entity = get_or_build_entity(object)

        if options[:partial] == :begin
          (0 .. term.length - 1).each do |subterm_length|
            subterm = term[0 .. subterm_length]
            entity.add_keyword(subterm, priority + subterm_length)
          end
        end

        if options[:partial] == :phone
          (4 .. term.length - 4).each do |subterm_length|
            subterm = term[-subterm_length .. -1]
            entity.add_keyword(subterm, priority + subterm_length)
          end
        end

        entity.add_keyword(term, priority + PRIORITY_FULL_TERM)
      end


      def normalize_term(term)
        term.downcase.scan(/[\p{Word}]+/)
      end


      def get_or_build_entity(searchable_object)
        @entities[searchable_object.id] ||= SearchEntity.new(searchable_object)
      end


      def set_sub_order(sub_order, object)
        entity = get_or_build_entity(object)
        entity.set_sub_order(sub_order)
      end


      def searchable_birthday(db_birthday)
        month, day = db_birthday.split('-')
        day + '.' + month
      end

    end
  end
end
