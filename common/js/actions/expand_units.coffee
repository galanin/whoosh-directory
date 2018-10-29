import { Request } from '@lib/request'

import { SET_EXPANDED_UNITS, EXPAND_UNIT, EXPAND_UNITS, COLLAPSE_UNIT } from '@constants/expand_units';

export setExpandedUnits = (unit_ids) ->
  type: SET_EXPANDED_UNITS,
  unit_ids: unit_ids,

export expandUnit = (unit_id) ->
  type: EXPAND_UNIT,
  unit_id: unit_id,

export expandUnits = (unit_ids) ->
  type: EXPAND_UNITS,
  unit_ids: unit_ids,

export saveExpandedUnit = (unit_id) ->
  (dispatch, getState) ->
    state = getState()
    Request.post("/units/#{unit_id}/expand", session_token: state.session?.token).then()

export saveExpandedUnits = (unit_ids) ->
  (dispatch, getState) ->
    state = getState()
    Request.post("/units/#{unit_ids.join(',')}/expand", session_token: state.session?.token).then()

export collapseUnit = (unit_id) ->
  type: COLLAPSE_UNIT,
  unit_id: unit_id,

export saveCollapsedUnit = (unit_id) ->
  (dispatch, getState) ->
    state = getState()
    Request.post("/units/#{unit_id}/collapse", session_token: state.session?.token).then()
