import {
  SET_SEARCH_RUNNING
  SET_SEARCH_FINISHED
} from '@constants/search_cache'


export default (state = {}, action) ->
  switch action.type

    when SET_SEARCH_RUNNING
      new_state = Object.assign({}, state)
      new_state[action.query] = null
      new_state

    when SET_SEARCH_FINISHED
      new_state = Object.assign({}, state)
      new_cache =
        type: action.search_type
        results: action.results
        birthday_interval: action.birthday_interval
        birthdays: action.birthdays
      new_state[action.query] = new_cache
      new_state

    else
      state
