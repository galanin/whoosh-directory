import {
  SET_HUMAN_QUERY
  SET_MACHINE_QUERY
  SET_CURRENT_RESULTS
} from '@constants/search'


export default (state = {}, action) ->
  switch action.type

    when SET_HUMAN_QUERY
      new_state = Object.assign({}, state)
      new_state.query = action.query
      new_state

    when SET_MACHINE_QUERY
      new_state = Object.assign({}, state)
      new_state.current_machine_query = action.query
      new_state

    when SET_CURRENT_RESULTS
      new_state = Object.assign({}, state)
      new_state.results = action.results
      new_state

    else
      state
