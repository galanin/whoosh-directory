require_relative 'uniq_id.rb'

module ShortId
  extend ActiveSupport::Concern
  include Mongoid::Autoinc
  include UniqId

  included do
    field :short_id, type: String
    index({ short_id: 1 })
    after_initialize { assign_short_id }

    def assign_short_id
      self.short_id ||= create_uniq_id('short_id')
    end


  end
end
