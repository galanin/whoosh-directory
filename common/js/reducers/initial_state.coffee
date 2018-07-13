import {
  FETCH_INITIAL_STATE_REQUEST,
  FETCH_INITIAL_STATE_SUCCESS,
  FETCH_INITIAL_STATE_FAILURE
} from '@constants/initial_state'

export default (state = {}, action) ->
  switch action.type
    when FETCH_INITIAL_STATE_REQUEST
      { fetching: true }
    when FETCH_INITIAL_STATE_SUCCESS
      { fetching: false, finished: true, success: true }
    when FETCH_INITIAL_STATE_FAILURE
      { fetching: false, finished: true, success: false, error: action.error }
    else
      state
