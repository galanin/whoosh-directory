import { SET_UNITS } from '../const/units'

export setUnits = (units) ->
  type: SET_UNITS,
  organization_units: units,
