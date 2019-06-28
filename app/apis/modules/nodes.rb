module Staff
  class NodesAPI < Grape::API

    namespace 'nodes' do

      get do
        present :root_ids, Node.roots.order(root_sort: :asc).pluck(:short_id)
        present :nodes, Node.all.tree_fields
      end


      get ':node_ids' do
        node_ids = params[:node_ids].split(',')
        direct_nodes = Node.info_fields.in(short_id: node_ids)
        nodes = Node.info_fields.with_children(node_ids)

        present :nodes, nodes
        present :units, nodes.units
        present :employments, nodes.employments + direct_nodes.child_employments
        present :people, nodes.employments.people + direct_nodes.child_employments.people
        present :contacts, direct_nodes.child_contacts
      end

    end

  end
end
