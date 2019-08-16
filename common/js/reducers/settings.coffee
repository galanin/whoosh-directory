import {
  SET_SETTINGS
  SET_SETTING
} from '@constants/settings'


export default (state = {}, action) ->
  switch action.type

    when SET_SETTINGS
      action.settings

    when SET_SETTING
      new_state = Object.assign({}, state)
      new_state[action.key] = action.value
      new_state

    else
      state
