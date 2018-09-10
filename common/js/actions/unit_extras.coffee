import store from '../store'

import { Request } from '@lib/request'

import { START_LOAD_UNIT_EXTRA, ADD_UNIT_EXTRA, SET_UNIT_EXTRA_ERROR } from '@constants/unit_extras'
import { addPeople } from '@actions/people'
import { addEmployments } from '@actions/employments'


export loadUnitExtra = (unit_id) ->
  (dispatch, getState) ->
    state = getState()
    unless state.unit_extras[unit_id]?
      dispatch(startLoadUnitExtra(unit_id))

      Request.get("/units/#{unit_id}").then (result) ->
        dispatch(addPeople(result.body.people))
        dispatch(addEmployments(result.body.employments))
        dispatch(addUnitExtra(unit_id, result.body.unit_extra[0]))
      , (error) ->

export startLoadUnitExtra = (unit_id) ->
  type: START_LOAD_UNIT_EXTRA
  unit_id: unit_id

export addUnitExtra = (unit_id, unit_extra) ->
  type: ADD_UNIT_EXTRA
  unit_id: unit_id
  unit_extra: unit_extra

export setUnitExtraError = (unit_id, error) ->
  type: SET_UNIT_EXTRA_ERROR
  unit_id: unit_id
  error: error
