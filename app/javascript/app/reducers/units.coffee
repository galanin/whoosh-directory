import { SET_UNITS } from '../const/units';

export default (state = {}, action) ->
  switch action.type
    when SET_UNITS
      action.organization_units
    else
      state
