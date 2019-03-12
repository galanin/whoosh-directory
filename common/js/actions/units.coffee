import { Request } from '@lib/request'

import { ADD_UNITS } from '@constants/units'


export addUnits = (units) ->
  type: ADD_UNITS
  units: units
