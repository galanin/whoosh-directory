import { Request } from '@lib/request'
import { filter, join, isEmpty } from 'lodash'

import { ADD_EMPLOYMENTS } from '@constants/employments'
import { addPeople } from '@actions/people'
import { addUnitTitles } from '@actions/unit_titles'


export addEmployments = (employments) ->
  type: ADD_EMPLOYMENTS
  employments: employments


export getParentIds = (state, employment) ->
  return [] if isEmpty(state.units)

  unit_ids = getParentUnitIds(state, employment)
  for unit_id in unit_ids
    unit = state.units[unit_id]
    first_employment_id = unit.employ_ids?[0]
    first_employment = state.employments[first_employment_id]

    unit_id: unit_id
    employment_id: if first_employment?.is_boss then first_employment_id else null


export getParentUnitIds = (state, employment) ->
  return [] if isEmpty(state.units)

  unit = state.units[employment.unit_id]
  is_boss_him_herself = unit.employ_ids[0] == employment.id
  if is_boss_him_herself
    unit.path
  else
    unit.full_path


getMissingUnitTitleIds = (state, unit_ids) ->
  unit_ids.filter (unit_id) -> !state.unit_titles[unit_id]?


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
        dispatch(addUnitTitles(response.body.unit_titles))


export loadEmploymentHierarchy = (employment_id) ->
  (dispatch, getState) ->
    state = getState()
    employment = state.employments[employment_id]
    missing_employ_ids = getMissingParentEmployIds(state, employment)
    if missing_employ_ids.length > 0
      dispatch(loadEmployments(missing_employ_ids))
