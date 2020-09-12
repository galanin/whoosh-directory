import { clone, without, isArray } from 'lodash';
import { LOCATION_CHANGE } from 'connected-react-router';
import { getNewUrlParam } from '@lib/url-parsing';

import {
  ADD_NODE_TREE,
  ADD_NODE_DATA,
  LOADED_NODE_IDS,
  SET_EXPANDED_NODES,
  COLLAPSE_NODE,
  EXPAND_NODE,
  SET_CURRENT_NODE,
  SCROLL_TO_NODE,
  SCROLLED_TO_NODE
} from '@constants/nodes';

import { URL_PARAM_NODE } from '@constants/url-parsing';

const setChildrenParent = (nodes, node) => {
  if (isArray(node.c)) {
    return node.c.map(child_id => (nodes[child_id].parent_id = node.id));
  }
};

const getParentPath = (nodes, node) => {
  if (node.parent_id) {
    const parent_node = nodes[node.parent_id];
    setPath(nodes, parent_node);
    return parent_node.full_path;
  } else {
    return [];
  }
};

const setPath = (nodes, node) => {
  if (!node.path) {
    node.path = getParentPath(nodes, node);
  }
  return node.full_path || (node.full_path = [...node.path, node.id]);
};

const default_state = {
  root_ids: [],
  tree: {},
  data: {},
  loaded: {},
  expanded: {},
  current_id: null,
  scroll_to_id: null
};

export default (state, action) => {
  let id, node, node_id;
  if (state == null) {
    state = default_state;
  }
  switch (action.type) {
    case ADD_NODE_TREE:
      var new_tree = clone(state.tree);

      for (node of action.nodes) {
        new_tree[node.id] = node;
      }

      for (id in new_tree) {
        node = new_tree[id];
        setChildrenParent(new_tree, node);
      }
      for (id in new_tree) {
        node = new_tree[id];
        setPath(new_tree, node);
      }

      var new_state = clone(state);
      new_state.root_ids = action.root_ids;
      new_state.tree = new_tree;

      return new_state;

    case ADD_NODE_DATA:
      var new_data = clone(state.data);
      for (node of action.nodes) {
        new_data[node.id] = node;
      }

      new_state = clone(state);
      new_state.data = new_data;

      return new_state;

    case LOADED_NODE_IDS:
      var new_loaded = clone(state.loaded);
      for (node_id of action.node_ids) {
        new_loaded[node_id] = true;
      }

      new_state = clone(state);
      new_state.loaded = new_loaded;

      return new_state;

    case SET_EXPANDED_NODES:
      var new_expanded = {};
      for (node_id of action.node_ids) {
        new_expanded[node_id] = true;
      }

      new_state = clone(state);
      new_state.expanded = new_expanded;

      return new_state;

    case COLLAPSE_NODE:
      new_expanded = clone(state.expanded);
      delete new_expanded[action.node_id];

      new_state = clone(state);
      new_state.expanded = new_expanded;

      return new_state;

    case EXPAND_NODE:
      new_expanded = clone(state.expanded);

      var node_ids = isArray(action.node_id)
        ? action.node_id
        : [action.node_id];
      for (node_id of node_ids) {
        new_expanded[node_id] = true;
      }

      new_state = clone(state);
      new_state.expanded = new_expanded;

      return new_state;

    case SET_CURRENT_NODE:
      new_state = clone(state);
      new_state.current_id = action.node_id;

      return new_state;

    case SCROLL_TO_NODE:
      new_state = clone(state);
      new_state.scroll_to_id = action.node_id;

      return new_state;

    case SCROLLED_TO_NODE:
      new_state = clone(state);
      if (new_state.scroll_to_id === action.node_id) {
        new_state.scroll_to_id = null;
      }

      return new_state;

    case LOCATION_CHANGE:
      if (action.payload.action === 'POP') {
        const new_node_id = getNewUrlParam(action.payload, URL_PARAM_NODE);

        if (new_node_id !== state.current_id) {
          new_state = clone(state);
          new_state.current_id = new_node_id;

          return new_state;
        } else {
          return state;
        }
      } else {
        return state;
      }

    default:
      return state;
  }
};
