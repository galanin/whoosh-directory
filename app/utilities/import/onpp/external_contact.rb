module Utilities
  module Import
    module ONPP
      class ExternalContact

        attr_accessor :external_id,
                      :unit_external_id,
                      :first_name,
                      :middle_name,
                      :last_name,
                      :post_title,
                      :birthday,
                      :office,
                      :building,
                      :phones,
                      :email


        def initialize(source_data, unit_id)
          @external_id      = source_data['id']
          @unit_external_id = unit_id
          @first_name       = source_data['first_name']
          @middle_name      = source_data['middle_name']
          @last_name        = source_data['last_name']
          @post_title       = source_data['post_title']
          @birthday         = source_data['birthday']
          @office           = source_data['office']
          @building         = source_data['building']
          @phones           = source_data['phones'].split(',')
          @email            = source_data['email']

        end


        def attributes
          {
            external_id:      external_id,
            unit_external_id: unit_external_id,
            first_name:       first_name,
            middle_name:      middle_name,
            last_name:        last_name,
            post_title:       post_title,
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
