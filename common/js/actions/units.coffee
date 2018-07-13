import { SET_UNITS } from '@constants/units'

export setUnits = (units) ->
  type: SET_UNITS,
  organization_units: units,
