import { SET_SESSION_TOKEN } from '@constants/session'

export default (state = {}, action) ->
  switch action.type
    when SET_SESSION_TOKEN
      { token: action.token }

    else
      state
