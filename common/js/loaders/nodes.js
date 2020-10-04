import { isEmpty } from 'lodash';

import { loadMissingNodeData } from '@actions/nodes';

const requested_node_ids = {};

const loadNode = (store, node_id) => {
  if (!requested_node_ids[node_id]) {
    const state = store.getState();
    if (!isEmpty(state.nodes.tree)) {
      requested_node_ids[node_id] = true;
      return store.dispatch(loadMissingNodeData(node_id));
    }
  }
};

export default store =>
  store.subscribe(() => {
    const state = store.getState();

    const node_id = state.nodes.current_id;

    if (node_id) {
      return loadNode(store, node_id);
    }
  });
