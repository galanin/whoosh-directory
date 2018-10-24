module Utilities
  module Import
    class SearchIndex

      PRIORITY_FULL_TERM   = 100
      PRIORITY_LAST_NAME   = 6
      PRIORITY_FIRST_NAME  = 5
      PRIORITY_MIDDLE_NAME = 4
      PRIORITY_UNIT_TITLE  = 3
      PRIORITY_POST_TITLE  = 2
      PRIORITY_LOWEST      = 1

      def initialize
        @entities = {}
      end


      def add_object(object)
        case object
        when Person then add_person(object)
        when Unit then add_unit(object)
        when Employment then add_employment(object)
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
        add_term(person.last_name, PRIORITY_LAST_NAME, person, partial: true)
        add_term(person.first_name, PRIORITY_FIRST_NAME, person, partial: true)
        add_term(person.middle_name, PRIORITY_MIDDLE_NAME, person, partial: true)
        add_normal_term(person.birthday, PRIORITY_LOWEST, person) if person.birthday
        set_sub_order(person.last_name + ' ' + person.first_name + ' ' + person.middle_name, person)
      end


      def add_unit(unit)
        puts unit.long_title
        add_term(unit.long_title, PRIORITY_UNIT_TITLE, unit, partial: true)
        add_term(unit.short_title, PRIORITY_UNIT_TITLE, unit, partial: true)
        set_sub_order(unit.list_title, unit)
      end


      def add_employment(employment)
        person = employment.person
        add_term(employment.post_title, PRIORITY_LOWEST, person, partial: true)
        add_term(employment.office, PRIORITY_LOWEST, person)
        add_term(employment.building, PRIORITY_LOWEST, person)
        employment.phones.each do |phone|
          add_term(phone, PRIORITY_LOWEST, person)
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
            entity.destroy
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
        entity = @entities[get_entity_key(entry.searchable)] ||= SearchEntity.new
        entity.search_entry = entry
      end


      def add_term(term, priority, object, options = {})
        normalize_term(term).each do |normal_term|
          add_normal_term(normal_term, priority, object, options)
        end
      end


      def add_normal_term(term, priority, object, options = {})
        entity = get_or_build_entity(object)

        if options[:partial]
          (0 .. term.length - 1).each do |subterm_length|
            subterm = term[0 .. subterm_length]
            entity.add_keyword(subterm, priority + subterm_length)
          end
        end

        entity.add_keyword(term, priority + PRIORITY_FULL_TERM)
      end


      def normalize_term(term)
        term.downcase.scan(/[\p{Word}]+/)
      end


      def get_or_build_entity(searchable_object)
        @entities[get_entity_key(searchable_object)] ||= SearchEntity.new(searchable_object)
      end


      def get_entity_key(searchable_object)
        searchable_object.id.to_s
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
