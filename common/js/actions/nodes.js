/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
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


export var loadNodeTree = () => dispatch => Request.get('/nodes').then(result => dispatch(addNodeTree(result.body.nodes, result.body.root_ids))
  , function(error) {});


export var addNodeTree = (nodes, root_ids) => ({
  type: ADD_NODE_TREE,
  nodes,
  root_ids
});


const filterLoadedNodeIds = (state, node_ids) => reject(node_ids, node_id => state.nodes.loaded[node_id]);


export var loadMissingNodeData = node_ids => (function(dispatch, getState) {
  const state = getState();
  if (!isArray(node_ids)) { node_ids = [node_ids]; }

  const missing_node_ids = filterLoadedNodeIds(state, node_ids);

  if (missing_node_ids.length > 0) {
    return Request.get('/nodes/' + missing_node_ids.join(',')).then(function(result) {
      dispatch(addNodes(result.body.nodes));
      dispatch(addUnits(result.body.units));
      dispatch(addEmployments(result.body.employments));
      dispatch(addPeople(result.body.people));
      return dispatch(addContacts(result.body.contacts));
    }
      , function(error) {});
  }
});


export var addNodes = nodes => ({
  type: ADD_NODE_DATA,
  nodes
});


export var loadedNodeIds = nodes => ({
  type: LOADED_NODE_IDS,
  node_ids
});


export var loadExpandedNodes = () => (dispatch, getState) => UserRequest.get(getState, 'expanded_nodes').then(result => dispatch(setExpandedNodes(result.body.expanded_nodes))

  , function(error) {});


export var setExpandedNodes = node_ids => ({
  type: SET_EXPANDED_NODES,
  node_ids
});


export var collapseNode = node_id => ({
  type: COLLAPSE_NODE,
  node_id
});


export var saveCollapsedNode = node_id => (function(dispatch, getState) {
  let node_ids;
  if (!isArray(node_id)) { node_ids = [node_id]; }
  return UserRequest.delete(getState, 'expanded_nodes/' + node_ids.join(',')).then();
});


export var expandNodes = node_id => ({
  type: EXPAND_NODE,
  node_id
});

export var expandNode = expandNodes;


export var saveExpandedNodes = node_ids => (function(dispatch, getState) {
  if (!isArray(node_ids)) { node_ids = [node_ids]; }
  return UserRequest.post(getState, 'expanded_nodes/' + node_ids.join(',')).then();
});

export var saveExpandedNode = saveExpandedNodes;


export var setCurrentNodeId = node_id => ({
  type: SET_CURRENT_NODE,
  node_id
});


export var scrollToNode = node_id => ({
  type: SCROLL_TO_NODE,
  node_id
});


export var scrolledToNode = node_id => ({
  type: SCROLLED_TO_NODE,
  node_id
});


export var openFullNodePath = node_id => (function(dispatch, getState) {
  const node = getState().nodes.tree[node_id];

  if (!isEmpty(node != null ? node.path : undefined)) {
    dispatch(expandNodes(node.path));
    return dispatch(saveExpandedNodes(node.path));
  }
});


export var goToNodeInStructure = node_id => (function(dispatch) {
  dispatch(openFullNodePath(node_id));
  dispatch(setCurrentNodeId(node_id));
  return dispatch(scrollToNode(node_id));
});
