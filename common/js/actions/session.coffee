import { Request } from '@lib/request'

import { SET_SESSION_TOKEN } from '@constants/session'

export loadSession = ->
  (dispatch, getState) ->
    state = getState()
    Request.get('/session', session_token: state.session?.token).then (result) ->
      dispatch(setSessionToken(result.body.session_token))

    , (error) ->


export setSessionToken = (token) ->
  type: SET_SESSION_TOKEN,
  token: token,
