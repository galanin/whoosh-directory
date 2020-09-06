/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import { padStart } from 'lodash';


export var padNumber = function(number, length) {
  if (length == null) { length = 2; }
  const number_str = number.toString();
  return padStart(number_str, length, '0');
};

