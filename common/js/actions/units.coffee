import { Request } from '@lib/request'

import { SET_UNITS, LOAD_UNIT_INFO, SHOW_UNIT_INFO, SHOW_UNIT_ERROR } from '@constants/units'
import { addPeople } from '@actions/people'
import { addEmployments } from '@actions/employments'

export setUnits = (units) ->
  type: SET_UNITS
  units: units

export loadUnitInfo = (unit_id) ->
  (dispatch) ->
    Request.get("/units/#{unit_id}").then (result) ->
      dispatch(addPeople(result.body.people))
      dispatch(addEmployments(result.body.employments))
      dispatch(showUnitInfo(result.body.unit_info[0]))
    , (error) ->

export showUnitInfo = (unit_info) ->
  type: SHOW_UNIT_INFO
  unit_info: unit_info

export showUnitError = (error) ->
  type: SHOW_UNIT_ERROR
  error: error
