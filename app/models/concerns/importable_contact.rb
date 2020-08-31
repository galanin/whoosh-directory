module ImportableContact
  extend ActiveSupport::Concern

  included do

    def link_parent_node(parent_node)
      self.parent_node_id       = parent_node&.id
      self.parent_node_short_id = parent_node&.short_id
    end

  end
end
