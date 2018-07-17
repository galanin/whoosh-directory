import { SET_EXPANDED_UNITS, EXPAND_UNIT, COLLAPSE_UNIT } from '@constants/expand_units'

export default (state = {}, action) ->
  switch action.type
    when SET_EXPANDED_UNITS
      Object.assign({}, action.unit_hash)
    when EXPAND_UNIT
      new_state = Object.assign({}, state)
      new_state[action.unit_id] = 1
      new_state
    when COLLAPSE_UNIT
      new_state = Object.assign({}, state)
      delete new_state[action.unit_id]
      new_state
    else
      state
