import {
  SET_UNITS,
  LOAD_UNIT_INFO,
} from '@constants/units'

export default (state = {}, action) ->
  switch action.type
    when SET_UNITS
      action.organization_units
    else
      state
