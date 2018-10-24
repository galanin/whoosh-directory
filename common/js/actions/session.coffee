import { Request } from '@lib/request'

import { SET_SESSION_TOKEN } from '@constants/session'
import { setExpandedUnits } from '@actions/expand_units'

export loadSession = ->
  (dispatch, getState) ->
    state = getState()
    Request.get('/session', session_token: state.session?.token).then (result) ->
      dispatch(setSessionToken(result.body.session_token))
      dispatch(setExpandedUnits(result.body.expanded_units))
    , (error) ->


export setSessionToken = (token) ->
  type: SET_SESSION_TOKEN,
  token: token,
