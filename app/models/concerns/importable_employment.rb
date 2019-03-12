module ImportableEmployment
  extend ActiveSupport::Concern

  included do


    def link_node(node)
      self.node          = node
      self.node_short_id = node&.short_id
    end


    def link_parent_node(parent_node)
      self.parent_node          = parent_node
      self.parent_node_short_id = parent_node&.short_id
    end


    def link_person_and_employment
      self.person_short_id = self.person.short_id
      self.person.employments << self
      self.person.employ_ids ||= []
      self.person.employ_ids << self.short_id
    end

  end
end
