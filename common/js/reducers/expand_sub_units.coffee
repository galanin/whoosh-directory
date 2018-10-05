import { RESET_EXPANDED_SUB_UNITS, EXPAND_SUB_UNIT, COLLAPSE_SUB_UNIT } from '@constants/expand_sub_units'

export default (state = {}, action) ->
  switch action.type
    when RESET_EXPANDED_SUB_UNITS
      {}

    when EXPAND_SUB_UNIT
      new_state = Object.assign({}, state)
      new_state[action.unit_id] = 1
      new_state

    when COLLAPSE_SUB_UNIT
      new_state = Object.assign({}, state)
      delete new_state[action.unit_id]
      new_state

    else
      state
