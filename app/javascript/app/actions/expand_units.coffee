import { SET_EXPANDED_UNITS, EXPAND_UNIT, COLLAPSE_UNIT } from '../const/expand_units';

export setExpandedUnits = (unit_ids) ->
  type: SET_EXPANDED_UNITS,
  unit_ids: unit_ids,

export expandUnit = (unit_id) ->
  type: EXPAND_UNIT,
  unit_id: unit_id,

export collapseUnit = (unit_id) ->
  type: COLLAPSE_UNIT,
  unit_id: unit_id,
