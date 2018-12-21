import { Request } from '@lib/request'
import { filter, join } from 'lodash'

import { ADD_EMPLOYMENTS } from '@constants/employments'
import { addPeople } from '@actions/people'

export addEmployments = (employments) ->
  type: ADD_EMPLOYMENTS
  employments: employments


export getParentUnitIds = (state, employment) ->
  unit = state.units[employment.unit_id]
  is_boss_him_herself = unit.employ_ids[0] == employment.id
  if is_boss_him_herself
    unit.path
  else
    unit.full_path


export getParentUnits = (state, employment) ->
  state.units[u_id] for u_id in getParentUnitIds(state, employment)


export getParentEmployIds = (state, employment) ->
  unit.employ_ids?[0] for unit in getParentUnits(state, employment)


export getParentEmploys = (state, employment) ->
  state.employments[e_id] for e_id in getParentEmployIds(state, employment)


getMissingParentEmployIds = (state, employment) ->
  parent_employ_ids = getParentEmployIds(state, employment)
  raw_employ_ids = ((if state.employments[e_id] then false else e_id) for e_id in parent_employ_ids)
  filter(raw_employ_ids)


export loadEmploymentHierarchy = (employment_id) ->
  (dispatch, getState) ->
    state = getState()
    employment = state.employments[employment_id]
    missing_employ_ids = getMissingParentEmployIds(state, employment)
    if missing_employ_ids.length > 0
      Request.get('/employments/' + join(missing_employ_ids, ',')).then (response) ->
        dispatch(addPeople(response.body.people))
        dispatch(addEmployments(response.body.employments))
