import {
  START_LOAD_UNIT_EXTRA
  FINISH_LOAD_UNIT_EXTRA
  SET_UNIT_EXTRA_ERROR
} from '@constants/unit_extras'

export default (state = {}, action) ->
  switch action.type
    when START_LOAD_UNIT_EXTRA
      unless state[action.unit_id]?
        new_state = Object.assign({}, state)
        new_state[action.unit_id] = { loading: true }
        new_state
      else
        state

    when FINISH_LOAD_UNIT_EXTRA
      new_state = Object.assign({}, state)
      new_state[action.unit_id] = { loaded: true }
      new_state

    when SET_UNIT_EXTRA_ERROR
      new_state = Object.assign({}, state)
      new_state[action.unit_id] = { failed: true }
      new_state

    else
      state
