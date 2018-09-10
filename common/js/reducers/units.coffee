import {
  SET_UNITS,
  LOAD_UNIT_INFO,
} from '@constants/units'

export default (state = {}, action) ->
  switch action.type
    when SET_UNITS
      units = {}
      action.units.forEach (unit) ->
        units[unit.id] = unit
      units

    else
      state
