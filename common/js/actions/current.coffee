import {
  SET_CURRENT_UNIT_ID,
  SET_CURRENT_EMPLOYMENT_ID,
} from '@constants/current'

export setCurrentUnitId = (unit_id) ->
  type: SET_CURRENT_UNIT_ID
  unit_id: unit_id

export setCurrentEmploymentId = (employment_id) ->
  type: SET_CURRENT_EMPLOYMENT_ID
  employment_id: employment_id
