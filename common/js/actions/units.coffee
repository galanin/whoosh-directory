import { Request } from '@lib/request'

import { SET_UNITS } from '@constants/units'

import { expandUnits, saveExpandedUnits } from '@actions/expand_units'
import { setCurrentUnitId, setHighlightedUnitId, scrollToUnit } from '@actions/current'


export loadUnits = ->
  (dispatch) ->
    Request.get('/units').then (result) ->
      dispatch(setUnits(result.body.units))
    , (error) ->


export setUnits = (units) ->
  type: SET_UNITS
  units: units


export openFullPath = (unit_id) ->
  (dispatch, getState) ->
    state = getState()
    unit = state.units[unit_id]
    parent_ids = []
    current_unit = unit
    while current_unit.parent_id?
      parent_ids.push current_unit.parent_id
      current_unit = state.units[current_unit.parent_id]

    if parent_ids.length > 0
      dispatch(expandUnits(parent_ids))
      dispatch(saveExpandedUnits(parent_ids))


export highlightUnit = (unit_id) ->
  (dispatch) ->
    dispatch(openFullPath(unit_id))
    dispatch(setHighlightedUnitId(unit_id))
    dispatch(scrollToUnit(unit_id))


export goToUnitInStructure = (unit_id) ->
  (dispatch) ->
    dispatch(openFullPath(unit_id))
    dispatch(setCurrentUnitId(unit_id))
    dispatch(scrollToUnit(unit_id))
