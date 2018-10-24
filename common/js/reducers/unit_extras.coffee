import {
  START_LOAD_UNIT_EXTRA,
  ADD_UNIT_EXTRAS,
  SET_UNIT_EXTRA_ERROR,
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

    when ADD_UNIT_EXTRAS
      new_state = Object.assign({}, state)
      action.unit_extras.forEach (unit_extra) ->
        new_state[unit_extra.id] = { loaded: true, extra: unit_extra }
      new_state

    when SET_UNIT_EXTRA_ERROR
      new_state = Object.assign({}, state)
      new_state[action.unit_id] = { failed: true }
      new_state

    else
      state
