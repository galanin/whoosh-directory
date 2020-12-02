import { SET_BIRTHDAY_RESULTS } from '@constants/birthdays';

export default (function(state, action) {
  if (!state) {
    state = {};
  }
  switch (action.type) {
    case SET_BIRTHDAY_RESULTS:
      var new_birthdays = Object.assign({}, state);
      action.birthdays.forEach(
        birthday => (new_birthdays[birthday.birthday] = birthday)
      );
      return new_birthdays;

    default:
      return state;
  }
});
