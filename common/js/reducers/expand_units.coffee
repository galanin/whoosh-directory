import { SET_EXPANDED_UNITS, EXPAND_UNIT, COLLAPSE_UNIT } from '@constants/expand_units';

export default (state = {}, action) ->
  switch action.type
    when SET_EXPANDED_UNITS
      new Set(action.unit_ids)
    when EXPAND_UNIT
      new_state = new Set(state)
      new_state.add(action.unit_id)
      new_state
    when COLLAPSE_UNIT
      new_state = new Set(state)
      new_state.delete(action.unit_id)
      new_state
    else
      state
