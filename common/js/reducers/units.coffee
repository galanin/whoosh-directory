import { clone } from 'lodash'

import { ADD_UNITS } from '@constants/units'


export default (state = {}, action) ->
  switch action.type
    when ADD_UNITS
      new_units = clone(state)

      new_units[unit.id] = unit for unit in action.units

      new_units

    else
      state
