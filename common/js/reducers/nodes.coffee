import { clone, without, isArray } from 'lodash'
import { LOCATION_CHANGE } from 'connected-react-router'
import { getNewUrlParam } from '@lib/url-parsing'

import {
  ADD_NODE_TREE
  ADD_NODE_DATA
  LOADED_NODE_IDS
  SET_EXPANDED_NODES
  COLLAPSE_NODE
  EXPAND_NODE
  SET_CURRENT_NODE
  SCROLL_TO_NODE
  SCROLLED_TO_NODE
} from '@constants/nodes'

import {
  URL_PARAM_NODE
} from '@constants/url-parsing'

setChildrenParent = (nodes, node) ->
  if isArray(node.c)
    for child_id in node.c
      nodes[child_id].parent_id = node.id


getParentPath = (nodes, node) ->
  if node.parent_id
    parent_node = nodes[node.parent_id]
    setPath(nodes, parent_node)
    parent_node.full_path
  else
    []


setPath = (nodes, node) ->
  node.path ||= getParentPath(nodes, node)
  node.full_path ||= [node.path..., node.id]


default_state =
  root_ids: []
  tree: {}
  data: {}
  loaded: {}
  expanded: {}
  current_id: null
  scroll_to_id: null

export default (state = default_state, action) ->
  switch action.type
    when ADD_NODE_TREE
      new_tree = clone(state.tree)

      new_tree[node.id] = node for node in action.nodes

      setChildrenParent new_tree, node for id, node of new_tree
      setPath new_tree, node for id, node of new_tree

      new_state = clone(state)
      new_state.root_ids = action.root_ids
      new_state.tree = new_tree

      new_state

    when ADD_NODE_DATA
      new_data = clone(state.data)
      new_data[node.id] = node for node in action.nodes

      new_state = clone(state)
      new_state.data = new_data

      new_state

    when LOADED_NODE_IDS
      new_loaded = clone(state.loaded)
      new_loaded[node_id] = true for node_id in action.node_ids

      new_state = clone(state)
      new_state.loaded = new_loaded

      new_state

    when SET_EXPANDED_NODES
      new_expanded = {}
      new_expanded[node_id] = true for node_id in action.node_ids

      new_state = clone(state)
      new_state.expanded = new_expanded

      new_state

    when COLLAPSE_NODE
      new_expanded = clone(state.expanded)
      delete new_expanded[action.node_id]

      new_state = clone(state)
      new_state.expanded = new_expanded

      new_state

    when EXPAND_NODE
      new_expanded = clone(state.expanded)

      node_ids = if isArray(action.node_id) then action.node_id else [action.node_id]
      new_expanded[node_id] = true for node_id in node_ids

      new_state = clone(state)
      new_state.expanded = new_expanded

      new_state

    when SET_CURRENT_NODE
      new_state = clone(state)
      new_state.current_id = action.node_id

      new_state

    when SCROLL_TO_NODE
      new_state = clone(state)
      new_state.scroll_to_id = action.node_id

      new_state

    when SCROLLED_TO_NODE
      new_state = clone(state)
      if new_state.scroll_to_id == action.node_id
        new_state.scroll_to_id = null

      new_state

    when LOCATION_CHANGE
      if action.payload.action == 'POP'
        new_node_id = getNewUrlParam(action.payload, URL_PARAM_NODE)

        if new_node_id != state.current_id
          new_state = clone(state)
          new_state.current_id = new_node_id

          new_state

        else
          state

      else
        state

    else
      state
