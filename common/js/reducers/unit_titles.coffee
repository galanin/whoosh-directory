import {
  ADD_UNIT_TITLES
} from '@constants/unit_titles'

export default (state = {}, action) ->
  switch action.type
    when ADD_UNIT_TITLES
      new_state = Object.assign({}, state)
      action.unit_titles.forEach (unit_title) ->
        new_state[unit_title.id] = unit_title
      new_state

    else
      state
