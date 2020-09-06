/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import { ADD_EMPLOYMENTS } from '@constants/employments';

export default (function(state, action) {
  if (state == null) { state = {}; }
  switch (action.type) {
    case ADD_EMPLOYMENTS:
      var new_employments = Object.assign({}, state);
      action.employments.forEach(employment => new_employments[employment.id] = employment);
      return new_employments;

    default:
      return state;
  }
});
