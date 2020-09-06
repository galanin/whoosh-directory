/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import { SET_BIRTHDAY_RESULTS } from '@constants/birthdays';

export default (function(state, action) {
  if (state == null) { state = {}; }
  switch (action.type) {
    case SET_BIRTHDAY_RESULTS:
      var new_birthdays = Object.assign({}, state);
      action.birthdays.forEach(birthday => new_birthdays[birthday.birthday] = birthday);
      return new_birthdays;

    default:
      return state;
  }
});
