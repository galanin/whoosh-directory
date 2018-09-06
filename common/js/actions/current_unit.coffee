import { SET_CURRENT_UNIT_ID } from '@constants/current_unit'

export setCurrentUnitId = (unit_id) ->
  type: SET_CURRENT_UNIT_ID
  unit_id: unit_id
