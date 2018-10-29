import {
  SET_CURRENT_UNIT_ID
  SET_HIGHLIGHTED_UNIT_ID
  SET_CURRENT_EMPLOYMENT_ID
  SCROLL_TO_UNIT
  SCROLLED_TO_UNIT
} from '@constants/current'

export setCurrentUnitId = (unit_id) ->
  type: SET_CURRENT_UNIT_ID
  unit_id: unit_id

export setHighlightedUnitId = (unit_id) ->
  type: SET_HIGHLIGHTED_UNIT_ID
  unit_id: unit_id

export setCurrentEmploymentId = (employment_id) ->
  type: SET_CURRENT_EMPLOYMENT_ID
  employment_id: employment_id

export scrollToUnit = (unit_id) ->
  type: SCROLL_TO_UNIT
  unit_id: unit_id

export scrolledToUnit = (unit_id) ->
  type: SCROLLED_TO_UNIT
  unit_id: unit_id
