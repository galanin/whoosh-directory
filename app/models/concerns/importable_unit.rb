module ImportableUnit
  extend ActiveSupport::Concern

  included do


    def link_node(node)
      self.node          = node
      self.node_short_id = node&.short_id
    end


    def link_head(employment)
      self.head          = employment
      self.head_short_id = employment&.short_id
    end

  end
end
