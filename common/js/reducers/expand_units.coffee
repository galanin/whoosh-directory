import { SET_EXPANDED_UNITS, EXPAND_UNIT, EXPAND_UNITS, COLLAPSE_UNIT } from '@constants/expand_units'

export default (state = {}, action) ->
  switch action.type
    when SET_EXPANDED_UNITS
      new_state = {}
      action.unit_ids.forEach (unit_id) ->
        new_state[unit_id] = 1
      new_state

    when EXPAND_UNIT
      new_state = Object.assign({}, state)
      new_state[action.unit_id] = 1
      new_state

    when EXPAND_UNITS
      new_state = Object.assign({}, state)
      action.unit_ids.forEach (unit_id) ->
        new_state[unit_id] = 1
      new_state

    when COLLAPSE_UNIT
      new_state = Object.assign({}, state)
      delete new_state[action.unit_id]
      new_state

    else
      state
