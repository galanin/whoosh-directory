import { ADD_EMPLOYMENTS } from '@constants/employments';

export default (state, action) => {
  if (state == null) {
    state = {};
  }
  switch (action.type) {
    case ADD_EMPLOYMENTS:
      var new_employments = Object.assign({}, state);
      action.employments.forEach(
        employment => (new_employments[employment.id] = employment)
      );
      return new_employments;

    default:
      return state;
  }
};
