/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import { ADD_PEOPLE } from '@constants/people';

export default (function(state, action) {
  if (state == null) { state = {}; }
  switch (action.type) {
    case ADD_PEOPLE:
      var new_people = Object.assign({}, state);
      action.people.forEach(person => new_people[person.id] = person);
      return new_people;

    default:
      return state;
  }
});
