import {
  SET_CURRENT_UNIT_ID
  SET_HIGHLIGHTED_UNIT_ID
  SET_CURRENT_EMPLOYMENT_ID
  SCROLL_TO_UNIT
  SCROLLED_TO_UNIT
} from '@constants/current'

export default (state = {}, action) ->
  switch action.type

    when SET_CURRENT_UNIT_ID
      new_state = Object.assign({}, state)
      new_state.unit_id = action.unit_id
      new_state

    when SET_HIGHLIGHTED_UNIT_ID
      new_state = Object.assign({}, state)
      new_state.highlighted_unit_id = action.unit_id
      new_state

    when SET_CURRENT_EMPLOYMENT_ID
      new_state = Object.assign({}, state)
      new_state.employment_id = action.employment_id
      new_state

    when SCROLL_TO_UNIT
      new_state = Object.assign({}, state)
      new_state.scroll_to_unit_id = action.unit_id
      new_state

    when SCROLLED_TO_UNIT
      new_state = Object.assign({}, state)
      if new_state.scroll_to_unit_id == action.unit_id
        delete new_state.scroll_to_unit_id
      new_state

    else
      state
