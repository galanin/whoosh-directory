/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import {
  SET_SEARCH_RUNNING,
  SET_SEARCH_FINISHED
} from '@constants/search_cache';


export default (function(state, action) {
  if (state == null) { state = {}; }
  switch (action.type) {

    case SET_SEARCH_RUNNING:
      var new_state = Object.assign({}, state);
      new_state[action.query] = null;
      return new_state;

    case SET_SEARCH_FINISHED:
      new_state = Object.assign({}, state);
      var new_cache = {
        type: action.search_type,
        results: action.results,
        birthday_interval: action.birthday_interval,
        birthdays: action.birthdays
      };
      new_state[action.query] = new_cache;
      return new_state;

    default:
      return state;
  }
});
