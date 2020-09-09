import { Request } from '@lib/request';

import { ADD_UNITS } from '@constants/units';

export const addUnits = units => ({
  type: ADD_UNITS,
  units
});
