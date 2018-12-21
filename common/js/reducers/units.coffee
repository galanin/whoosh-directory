import { isArray } from 'lodash'

import { SET_UNITS } from '@constants/units'


setChildrenParent = (units, unit) ->
  if isArray(unit.child_ids)
    for child_id in unit.child_ids
      units[child_id].parent_id = unit.id


getParentPath = (units, unit) ->
  if unit.parent_id
    parent_unit = units[unit.parent_id]
    setPath(units, parent_unit)
    parent_unit.full_path
  else
    []


setPath = (units, unit) ->
  unit.path ||= getParentPath(units, unit)
  unit.full_path ||= [unit.path..., unit.id]


export default (state = {}, action) ->
  switch action.type
    when SET_UNITS
      units = {}

      units[unit.id] = unit for unit in action.units

      setChildrenParent units, unit for id, unit of units
      setPath units, unit for id, unit of units

      units

    else
      state
