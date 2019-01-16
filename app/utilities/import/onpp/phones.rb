require 'nokogiri'

module Utilities
  module Import
    module ONPP
      class Phones

        attr_accessor :phone_w_type

        XML_PHONE_ATTR_NAME_WITH_TYPE = {
          "internal" => %w[int_phone int_phone_1 int_phone_2],
          "local"    => %w[work_phone work_phone_2],
          "mobile"   => %w[work_mob_phone],
        }


        def initialize(hash)
          @phone_w_type = hash
        end


        def self.from_yml(doc)
          if doc.nil?
            doc
          else
            result = doc.transform_values{|phone_array| phone_array.map(&:to_s)}
            Phones.new(result)
          end
        end


        def self.from_xml(doc)
          phone_w_type = {}
          XML_PHONE_ATTR_NAME_WITH_TYPE.each do |type, attr_name_array|
            phones = []
            attr_name_array.each do |attr_name|
              unless doc[attr_name].nil? or doc[attr_name].empty?
                phones << doc[attr_name]
              end
            end

            unless phones.empty?
               phone_w_type[type] = phones
            end
          end

          phone_w_type.empty? ? nil : Phones.new(phone_w_type)
        end


        def attributes
          {
            phone_w_type: phone_w_type,
          }
        end

      end
    end
  end
end
