require 'utilities/import/collection'
require 'utilities/import/demo/employment_entity_set'

module Utilities
  module Import
    module Demo
      class EmploymentCollection

        include Utilities::Import::Collection


        self.entity_class = Utilities::Import::Demo::EmploymentEntitySet
        self.object_class = ::Employment


        def assign_head_id(node_collection)
          fresh_entities.each do |entity|
            entity.assign_head_id(node_collection)
          end
        end


        def link_node_objects(node_collection)
          fresh_entities.each do |entity|
            entity.link_node_objects(node_collection)
          end
        end


        def objects_by_external_id(external_id)
          @entities[external_id]&.old_objects
        end


        def objects_by_external_ids(external_ids)
          external_ids&.map { |id| objects_by_external_id(id) }.compact.flatten
        end


        def assign_phone_numbers
          number_pool = PhoneNumbersPool.new
          offices = Offices.new(number_pool)
          @entities.each do |id, employment_entity|
            employment_entity.old_objects.each do |employment|
              employment.telephones.phone_w_type.delete('local')
              offices << employment
            end
          end
          offices.spread_numbers
        end

        private


        class Offices

          def initialize(number_pool)
            @number_pool = number_pool
            @offices = {}
          end

          def <<(employment)
            office_key = "#{ employment.building }:#{ employment.office }"
            @offices[office_key] ||= Office.new(@number_pool)
            @offices[office_key] << employment
          end

          def spread_numbers
            @offices.each { |k, office| office.spread_numbers }
          end
        end


        class Office
          MAX_EMPLOYEE_PER_NUMBER = 3

          def initialize(number_pool)
            @number_pool = number_pool
            @employments = []
            @uniq_phones = Set.new
          end

          def <<(employment)
            @employments << employment
            number = (employment.telephones&.phone_w_type || {})['internal']&.first
            @uniq_phones << number if number.present?
          end

          def spread_numbers
            append_phones
            make_office_pool
            @employments.each do |employment|
              if (number = (employment.telephones&.phone_w_type || {})['internal']&.first).present?
                allocate(number)
              else
                employment.telephones ||= Phones.new
                employment.telephones.phone_w_type ||= {}
                employment.telephones.phone_w_type['internal'] ||= []
                employment.telephones.phone_w_type['internal'][0] = allocate_free
              end
            end
          end

          private

          def append_phones
            phones_limit = (@employments.count + MAX_EMPLOYEE_PER_NUMBER - 1) / MAX_EMPLOYEE_PER_NUMBER
            @uniq_phones << @number_pool.allocate_free while @uniq_phones.count < phones_limit
          end

          def make_office_pool
            @office_pool = @uniq_phones.map { |number| Array.new(MAX_EMPLOYEE_PER_NUMBER, number) }.flatten
          end

          def allocate_free
            @office_pool.shift
          end

          def allocate(number)
            @office_pool.delete_at(@office_pool.find_index(number))
          end
        end


        class PhoneNumbersPool

          def initialize
            @free = all_phone_numbers.clone
          end

          def allocate_free
            @free.shift
          end

          def allocate(number)
            @free.delete(number)
          end

          private

          FIRST_DIGITS = Set.new(%w(2 3 4 5 6 7 8))
          def all_phone_numbers
            @numbers ||= ('0' .. '9').to_a.repeated_permutation(4).select { |p| p.first.in?(FIRST_DIGITS) }.map(&:join)
          end

        end

      end
    end
  end
end
