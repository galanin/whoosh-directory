let prev_day_offset_right;
import { loadCurrentBirthdays } from '@actions/birthdays';

let prev_day_offset_left = (prev_day_offset_right = undefined);

export default store =>
  store.subscribe(() => {
    const state = store.getState();

    const day_offset_left = state.birthday_period?.day_offset_left;
    const day_offset_right = state.birthday_period?.day_offset_right;

    if (
      day_offset_left !== prev_day_offset_left ||
      day_offset_right !== prev_day_offset_right
    ) {
      prev_day_offset_left = day_offset_left;
      prev_day_offset_right = day_offset_right;

      if (day_offset_left && day_offset_right) {
        return store.dispatch(loadCurrentBirthdays());
      }
    }
  });
