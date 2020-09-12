import { clone } from 'lodash';

import { ADD_UNITS } from '@constants/units';

export default (state, action) => {
  if (state == null) {
    state = {};
  }
  switch (action.type) {
    case ADD_UNITS:
      var new_units = clone(state);

      for (let unit of action.units) {
        new_units[unit.id] = unit;
      }

      return new_units;

    default:
      return state;
  }
};
