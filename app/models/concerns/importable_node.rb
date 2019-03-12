module ImportableNode
  extend ActiveSupport::Concern

  included do

    def link_parent(parent_node)
      self.parent          = parent_node
      self.parent_short_id = parent_node&.short_id
    end


    def link_children(child_nodes)
      self.children        = child_nodes
      self.child_short_ids = child_nodes.map(&:short_id)
    end


    def link_child_employments(employments)
      self.child_employments = employments
      self.employ_ids        = employments.map(&:short_id)
    end


    def link_employment(employment)
      self.employment          = employment
      self.employment_short_id = employment&.short_id
    end


    def link_unit(unit)
      self.unit = unit
      self.unit_short_id = unit&.short_id
    end

  end
end
