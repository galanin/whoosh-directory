/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import { ADD_PEOPLE } from '@constants/people';

export var addPeople = people => ({
  type: ADD_PEOPLE,
  people
});
