import store from '../store'

import { Request } from '@lib/request'

import { START_LOAD_UNIT_EXTRA, ADD_UNIT_EXTRAS, SET_UNIT_EXTRA_ERROR } from '@constants/unit_extras'
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
        dispatch(addUnitExtras(result.body.unit_extras))
      , (error) ->

export startLoadUnitExtra = (unit_id) ->
  type: START_LOAD_UNIT_EXTRA
  unit_id: unit_id

export addUnitExtras = (unit_extras) ->
  type: ADD_UNIT_EXTRAS
  unit_extras: unit_extras

export setUnitExtraError = (unit_id, error) ->
  type: SET_UNIT_EXTRA_ERROR
  unit_id: unit_id
  error: error
