/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import { clone } from 'lodash';

import { ADD_UNITS } from '@constants/units';


export default (function(state, action) {
  if (state == null) { state = {}; }
  switch (action.type) {
    case ADD_UNITS:
      var new_units = clone(state);

      for (let unit of Array.from(action.units)) { new_units[unit.id] = unit; }

      return new_units;

    default:
      return state;
  }
});
