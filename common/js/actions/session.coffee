import { SET_SESSION_TOKEN } from '@constants/session';

export setSessionToken = (token) ->
  type: SET_SESSION_TOKEN,
  token: token,
