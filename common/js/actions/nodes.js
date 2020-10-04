import { isArray, isEmpty, reject } from 'lodash';

import { Request, UserRequest } from '@lib/request';

import {
  ADD_NODE_DATA,
  ADD_NODE_TREE,
  COLLAPSE_NODE,
  EXPAND_NODE,
  LOADED_NODE_IDS,
  SCROLL_TO_NODE,
  SCROLLED_TO_NODE,
  SET_CURRENT_NODE,
  SET_EXPANDED_NODES
} from '@constants/nodes';

import { addUnits } from '@actions/units';
import { addEmployments } from '@actions/employments';
import { addPeople } from '@actions/people';
import { addContacts } from '@actions/contacts';

export const loadNodeTree = () => dispatch =>
  Request.get('/nodes').then(
    result => dispatch(addNodeTree(result.body.nodes, result.body.root_ids)),
    error => {}
  );

export const addNodeTree = (nodes, root_ids) => ({
  type: ADD_NODE_TREE,
  nodes,
  root_ids
});

const filterLoadedNodeIds = (state, node_ids) =>
  reject(node_ids, node_id => state.nodes.loaded[node_id]);

export const loadMissingNodeData = node_ids => (dispatch, getState) => {
  const state = getState();
  if (!isArray(node_ids)) {
    node_ids = [node_ids];
  }

  const missing_node_ids = filterLoadedNodeIds(state, node_ids);

  if (missing_node_ids.length > 0) {
    return Request.get('/nodes/' + missing_node_ids.join(',')).then(
      result => {
        dispatch(addNodes(result.body.nodes));
        dispatch(addUnits(result.body.units));
        dispatch(addEmployments(result.body.employments));
        dispatch(addPeople(result.body.people));
        return dispatch(addContacts(result.body.contacts));
      },
      error => {}
    );
  }
};

export const addNodes = nodes => ({
  type: ADD_NODE_DATA,
  nodes
});

export const loadedNodeIds = node_ids => ({
  type: LOADED_NODE_IDS,
  node_ids
});

export const loadExpandedNodes = () => (dispatch, getState) =>
  UserRequest.get(getState, 'expanded_nodes').then(
    result => dispatch(setExpandedNodes(result.body.expanded_nodes)),

    error => {}
  );

export const setExpandedNodes = node_ids => ({
  type: SET_EXPANDED_NODES,
  node_ids
});

export const collapseNode = node_id => ({
  type: COLLAPSE_NODE,
  node_id
});

export const saveCollapsedNode = node_id => (dispatch, getState) => {
  let node_ids;
  if (!isArray(node_id)) {
    node_ids = [node_id];
  }
  return UserRequest.delete(
    getState,
    'expanded_nodes/' + node_ids.join(',')
  ).then();
};

export const expandNodes = node_id => ({
  type: EXPAND_NODE,
  node_id
});

export const expandNode = expandNodes;

export const saveExpandedNodes = node_ids => (dispatch, getState) => {
  if (!isArray(node_ids)) {
    node_ids = [node_ids];
  }
  return UserRequest.post(
    getState,
    'expanded_nodes/' + node_ids.join(',')
  ).then();
};

export const saveExpandedNode = saveExpandedNodes;

export const setCurrentNodeId = node_id => ({
  type: SET_CURRENT_NODE,
  node_id
});

export const scrollToNode = node_id => ({
  type: SCROLL_TO_NODE,
  node_id
});

export const scrolledToNode = node_id => ({
  type: SCROLLED_TO_NODE,
  node_id
});

export const openFullNodePath = node_id => (dispatch, getState) => {
  const node = getState().nodes.tree[node_id];

  if (!isEmpty(node?.path)) {
    dispatch(expandNodes(node.path));
    return dispatch(saveExpandedNodes(node.path));
  }
};

export const goToNodeInStructure = node_id => dispatch => {
  dispatch(openFullNodePath(node_id));
  dispatch(setCurrentNodeId(node_id));
  return dispatch(scrollToNode(node_id));
};
