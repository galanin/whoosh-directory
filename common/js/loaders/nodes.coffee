import { isEmpty } from 'lodash'

import { loadMissingNodeData } from '@actions/nodes'


requested_node_ids = {}


loadNode = (store, node_id) ->
  unless requested_node_ids[node_id]?
    state = store.getState()
    unless isEmpty(state.nodes.tree)
      requested_node_ids[node_id] = true
      store.dispatch(loadMissingNodeData(node_id))


export default (store) ->
  store.subscribe ->
    state = store.getState()

    node_id = state.nodes.current_id

    if node_id?
      loadNode(store, node_id)
