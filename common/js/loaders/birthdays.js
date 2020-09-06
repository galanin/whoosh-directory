/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let prev_day_offset_right;
import { loadCurrentBirthdays } from '@actions/birthdays';


let prev_day_offset_left = (prev_day_offset_right = undefined);

export default store => store.subscribe(function() {
  const state = store.getState();

  const day_offset_left = state.birthday_period != null ? state.birthday_period.day_offset_left : undefined;
  const day_offset_right = state.birthday_period != null ? state.birthday_period.day_offset_right : undefined;

  if ((day_offset_left !== prev_day_offset_left) || (day_offset_right !== prev_day_offset_right)) {
    prev_day_offset_left = day_offset_left;
    prev_day_offset_right = day_offset_right;

    if ((day_offset_left != null) && (day_offset_right != null)) {
      return store.dispatch(loadCurrentBirthdays());
    }
  }
});
