import { UserRequest } from '@lib/request'

import {
  COLLAPSE_UNIT
  EXPAND_UNIT
  EXPAND_UNITS
  SET_EXPANDED_UNITS
} from '@constants/expand_units'


export loadExpandedUnits = ->
  (dispatch, getState) ->
    UserRequest.get(getState().session?.token, '/expanded_units').then (result) ->
      dispatch(setExpandedUnits(result.body.expanded_units))

    , (error) ->


export setExpandedUnits = (unit_ids) ->
  type: SET_EXPANDED_UNITS
  unit_ids: unit_ids


export expandUnit = (unit_id) ->
  type: EXPAND_UNIT
  unit_id: unit_id


export expandUnits = (unit_ids) ->
  type: EXPAND_UNITS
  unit_ids: unit_ids


export saveExpandedUnit = (unit_id) ->
  (dispatch, getState) ->
    UserRequest.post(getState().session?.token, "/expanded_units/#{unit_id}").then()


export saveExpandedUnits = (unit_ids) ->
  (dispatch, getState) ->
    UserRequest.post(getState().session?.token, "/expanded_units/#{unit_ids.join(',')}").then()


export collapseUnit = (unit_id) ->
  type: COLLAPSE_UNIT
  unit_id: unit_id


export saveCollapsedUnit = (unit_id) ->
  (dispatch, getState) ->
    UserRequest.delete(getState().session?.token, "/expanded_units/#{unit_id}").then()
