import { SET_UNITS } from '@constants/units'

export setUnits = (units) ->
  type: SET_UNITS
  units: units

