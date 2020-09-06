/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import { SET_SESSION_TOKEN } from '@constants/session';

export default (function(state, action) {
  if (state == null) { state = {}; }
  switch (action.type) {
    case SET_SESSION_TOKEN:
      return { token: action.token };

    default:
      return state;
  }
});
