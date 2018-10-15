import {
  SET_CURRENT_UNIT_ID,
  SET_CURRENT_EMPLOYMENT_ID,
} from '@constants/current'

export default (state = {}, action) ->
  switch action.type

    when SET_CURRENT_UNIT_ID
      new_state = Object.assign({}, state)
      new_state.unit_id = action.unit_id
      new_state

    when SET_CURRENT_EMPLOYMENT_ID
      new_state = Object.assign({}, state)
      new_state.employment_id = action.employment_id
      new_state

    else
      state
