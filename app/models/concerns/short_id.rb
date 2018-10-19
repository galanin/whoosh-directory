module ShortId
  extend ActiveSupport::Concern
  include Mongoid::Autoinc

  included do
    field :short_id, type: String
    index({ short_id: 1 })
    after_initialize { assign_short_id }

    def assign_short_id
      self.short_id ||= hashids.encode(incrementor.inc)
    end


    private


    def incrementor
      @@incrementor ||= Mongoid::Autoinc::Incrementor.new(self.class.name, 'short_id', {})
    end


    def hashids
      @@hashids ||= Hashids.new(self.class.name)
    end

  end
end
