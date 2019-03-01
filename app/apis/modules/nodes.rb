module Staff
  class NodesAPI < Grape::API

    namespace 'nodes' do

      get do
        present nodes: Node.all.tree_fields
      end


      get ':node_ids' do
        node_ids = params[:node_ids].split(',')
        nodes = Node.info_fields.in(short_id: node_ids)

        present :nodes, nodes
        present :units, nodes.units
        present :employments, nodes.employments
        present :people, nodes.employments.people
      end

    end

  end
end
