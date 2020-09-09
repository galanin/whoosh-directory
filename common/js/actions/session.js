import { Request } from '@lib/request';

import { SET_SESSION_TOKEN } from '@constants/session';

export const loadSession = () => (dispatch, getState) => {
  const state = getState();
  return Request.get('/session', {
    session_token: state.session != null ? state.session.token : undefined
  }).then(
    result => dispatch(setSessionToken(result.body.session_token)),
    error => {}
  );
};

export const setSessionToken = token => ({
  type: SET_SESSION_TOKEN,
  token
});
