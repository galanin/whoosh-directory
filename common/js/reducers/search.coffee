import {
  SET_QUERY,
  SET_RESULTS,
} from '@constants/search'

export default (state = {}, action) ->
  switch action.type

    when SET_QUERY
      new_state = Object.assign({}, state)
      new_state.query = action.query
      new_state

    when SET_RESULTS
      new_state = Object.assign({}, state)
      new_state.results = action.results
      new_state

    else
      state
