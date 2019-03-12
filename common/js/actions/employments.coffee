import { Request } from '@lib/request'
import { filter, join, isEmpty } from 'lodash'

import { ADD_EMPLOYMENTS } from '@constants/employments'
import { addPeople } from '@actions/people'
import { addUnits } from '@actions/units'


export addEmployments = (employments) ->
  type: ADD_EMPLOYMENTS
  employments: employments


export getNodeParents = (state, employment) ->
  return [] if isEmpty(state.nodes.tree)

  node_ids = getNodeParentIds(state, employment)

  for node_id in node_ids
    node = state.nodes.data[node_id]
    unit = state.units[node?.unit_id]
    head = state.employments[unit?.head_id]
    employment = state.employments[node?.employment_id]

    node: node
    unit: unit
    head: head
    employment: employment


export getNodeParentIds = (state, employment) ->
  return [] if isEmpty(state.nodes.tree)

  if employment.parent_node_id?
    tree_node = state.nodes.tree[employment.parent_node_id]
    if employment.is_head
      tree_node.path
    else
      tree_node.full_path

  else if employment.node_id?
    tree_node = state.nodes.tree[employment.node_id]
    tree_node.path

  else
    []


getMissingUnitIds = (state, unit_ids) ->
  unit_ids.filter (unit_id) -> !state.units[unit_id]?


export getParentUnits = (state, employment) ->
  state.units[u_id] for u_id in getParentUnitIds(state, employment)


export getParentEmployIds = (state, employment) ->
  raw_employ_ids = (unit.employ_ids?[0] for unit in getParentUnits(state, employment))
  filter(raw_employ_ids)


getMissingParentEmployIds = (state, employment) ->
  parent_employ_ids = getParentEmployIds(state, employment)
  raw_employ_ids = ((if state.employments[e_id] then false else e_id) for e_id in parent_employ_ids)
  filter(raw_employ_ids)


export loadEmployments = (employment_ids) ->
  (dispatch, getState) ->
    Request.get('/employments/' + join(employment_ids, ',')).then (response) ->
      dispatch(addPeople(response.body.people))
      dispatch(addEmployments(response.body.employments))


export loadUnitHierarchy = (employment_id) ->
  (dispatch, getState) ->
    state = getState()
    employment = state.employments[employment_id]
    parent_unit_ids = getParentUnitIds(state, employment)
    missing_unit_title_ids = getMissingUnitTitleIds(state, parent_unit_ids)
    if missing_unit_title_ids.length > 0
      Request.get('/units/titles/' + join(missing_unit_title_ids, ',')).then (response) ->
        dispatch(addUnits(response.body.units))


export loadEmploymentHierarchy = (employment_id) ->
  (dispatch, getState) ->
    state = getState()
    employment = state.employments[employment_id]
    missing_employ_ids = getMissingParentEmployIds(state, employment)
    if missing_employ_ids.length > 0
      dispatch(loadEmployments(missing_employ_ids))
