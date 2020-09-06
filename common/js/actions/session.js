/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import { Request } from '@lib/request';

import { SET_SESSION_TOKEN } from '@constants/session';

export var loadSession = () => (function(dispatch, getState) {
  const state = getState();
  return Request.get('/session', {session_token: (state.session != null ? state.session.token : undefined)}).then(result => dispatch(setSessionToken(result.body.session_token))

    , function(error) {});
});


export var setSessionToken = token => ({
  type: SET_SESSION_TOKEN,
  token
});
