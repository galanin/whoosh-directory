import { ADD_PEOPLE } from '@constants/people';

export default (state, action) => {
  if (!state) {
    state = {};
  }
  switch (action.type) {
    case ADD_PEOPLE:
      var new_people = Object.assign({}, state);
      action.people.forEach(person => (new_people[person.id] = person));
      return new_people;

    default:
      return state;
  }
};
