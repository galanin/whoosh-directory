module ImportablePerson
  extend ActiveSupport::Concern

  included do

    def link_employment(employment)
      self.employments << employment
      self.employ_ids = self.employments.pluck(:short_id)
    end

  end

end
