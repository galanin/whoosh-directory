import { isArray } from 'lodash';

import { SET_UNITS } from '@constants/units'

export default (state = {}, action) ->
  switch action.type
    when SET_UNITS
      units = {}
      action.units.forEach (unit) ->
        units[unit.id] = unit

      setChildrenParent = (unit) ->
        if isArray(unit.child_ids)
          for child_id in unit.child_ids
            units[child_id].parent_id = unit.id

      setChildrenParent unit for id, unit of units

      units

    else
      state
