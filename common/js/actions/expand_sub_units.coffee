import { RESET_EXPANDED_SUB_UNITS, EXPAND_SUB_UNIT, COLLAPSE_SUB_UNIT } from '@constants/expand_sub_units'

export resetExpandedSubUnits = ->
  type: RESET_EXPANDED_SUB_UNITS

export expandSubUnit = (unit_id) ->
  type: EXPAND_SUB_UNIT
  unit_id: unit_id

export collapseSubUnit = (unit_id) ->
  type: COLLAPSE_SUB_UNIT
  unit_id: unit_id
