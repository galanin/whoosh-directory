module ImportableNode
  extend ActiveSupport::Concern

  included do

    def link_parent(parent_node)
      self.parent_id       = parent_node&.id
      self.parent_short_id = parent_node&.short_id
    end


    def link_children(child_nodes)
      # self.children        = child_nodes # already linked
      self.child_short_ids = child_nodes.map(&:short_id)
    end


    def link_child_employments(employments)
      # self.child_employments = employments # already linked
      self.employ_ids        = employments.map(&:short_id)
    end


    def link_child_contacts(contacts)
      # self.child_contacts = contacts # already linked
      self.contact_ids    = contacts.map(&:short_id)
    end


    def link_employment(employment)
      self.employment_id       = employment&.id
      self.employment_short_id = employment&.short_id
    end


    def link_unit(unit)
      self.unit_id       = unit&.id
      self.unit_short_id = unit&.short_id
    end

  end
end
