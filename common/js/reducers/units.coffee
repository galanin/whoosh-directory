import { SET_UNITS } from '@constants/units'

export default (state = {}, action) ->
  switch action.type
    when SET_UNITS
      units = {}
      action.units.forEach (unit) ->
        units[unit.id] = unit
      units

    else
      state
