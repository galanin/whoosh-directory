/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import { Request } from '@lib/request';

import { ADD_UNITS } from '@constants/units';


export var addUnits = units => ({
  type: ADD_UNITS,
  units
});
