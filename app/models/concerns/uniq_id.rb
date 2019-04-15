module UniqId
  extend ActiveSupport::Concern

  included do

    def create_uniq_id(field_name)
      hashids.encode(incrementor(field_name).inc)
    end


    private


    def incrementor(field_name)
      @@incrementor ||= Mongoid::Autoinc::Incrementor.new(self.class.name, field_name, {})
    end


    def hashids
      @@hashids ||= Hashids.new(self.class.name)
    end

  end
end
