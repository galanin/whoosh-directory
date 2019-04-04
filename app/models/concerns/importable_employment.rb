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


    def link_person(person)
      self.person          = person
      self.person_short_id = person&.short_id
    end

  end
end
