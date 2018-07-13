import {
  SET_UNITS,
} from '@constants/units'

export default (state = {}, action) ->
  switch action.type
    when SET_UNITS
      action.organization_units
    else
      state
