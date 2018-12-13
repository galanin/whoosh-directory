module Utilities
  module Import
    module ONPP
      class ExternalContact

        attr_accessor :external_id,
                      :unit_external_id,
                      :first_name,
                      :middle_name,
                      :last_name,
                      :function_title,
                      :location_title,
                      :post_title, :post_code,
                      :birthday,
                      :gender,
                      :office,
                      :building,
                      :phones,
                      :email


        def initialize(source_data, unit_id)
          @external_id      = source_data['id'].to_s
          @unit_external_id = unit_id
          @first_name       = source_data['first_name']
          @middle_name      = source_data['middle_name']
          @last_name        = source_data['last_name']
          @function_title   = source_data['function_title']
          @location_title   = source_data['location_title']
          @gender           = source_data['gender']
          @post_title       = source_data['post_title']
          @post_code        = source_data['post_code']
          @birthday         = source_data['birthday']
          @office           = source_data['office']
          @building         = source_data['building']
          @phones           = source_data['phones'].to_s.gsub(/-/,'').split(',')
          @email            = source_data['email']
        end


        def attributes
          {
            external_id:      external_id,
            unit_external_id: unit_external_id,
            first_name:       first_name,
            middle_name:      middle_name,
            last_name:        last_name,
            function_title:   function_title,
            location_title:   location_title,
            gender:           gender,
            post_title:       post_title,
            post_code:        post_code,
            birthday:         birthday,
            office:           office,
            building:         building,
            phones:           phones,
            email:            email,
          }
        end

      end
    end
  end
end
