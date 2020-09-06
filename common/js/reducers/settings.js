/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import {
  SET_SETTINGS,
  SET_SETTING
} from '@constants/settings';


export default (function(state, action) {
  if (state == null) { state = {}; }
  switch (action.type) {

    case SET_SETTINGS:
      return action.settings;

    case SET_SETTING:
      var new_state = Object.assign({}, state);
      new_state[action.key] = action.value;
      return new_state;

    default:
      return state;
  }
});
