import { UserRequest } from '@lib/request'

import {
  LOADED_TO_CALL
  ADDING_TO_CALL
  CHECKING_TO_CALL
  CHANGED_TO_CALL
  DESTROYING_TO_CALL
  DESTROYED_TO_CALL
} from '@constants/to_call'

import { addPeople } from '@actions/people'
import { addEmployments } from '@actions/employments'


export loadToCall = ->
  (dispatch, getState) ->
    UserRequest.get(getState().session?.token, '/to_call').then (response) ->
      dispatch(loadedToCall(response.body.data, response.body.unchecked, response.body.checked_today))
      if response.body.people?
        dispatch(addPeople(response.body.people))
      if response.body.employments?
        dispatch(addEmployments(response.body.employments))

    , (error) ->


export loadedToCall = (data, unchecked, checked_today) ->
  type: LOADED_TO_CALL
  data: data
  unchecked: unchecked
  checked_today: checked_today


export addToCall = (employment_id) ->
  (dispatch, getState) ->
    dispatch(addingToCall(employment_id))
    UserRequest.post(getState().session?.token, '/to_call/' + employment_id).then (response) ->
      dispatch(changedToCall(response.body.to_call, response.body.unchecked, response.body.checked_today))

    , (error) ->


export addingToCall = (employment_id) ->
  type: ADDING_TO_CALL
  employment_id: employment_id


export checkToCall = (employment_id) ->
  (dispatch, getState) ->
    dispatch(checkingToCall(employment_id))
    UserRequest.post(getState().session?.token, '/to_call/' + employment_id + '/check').then (response) ->
      dispatch(changedToCall(response.body.to_call, response.body.unchecked, response.body.checked_today))

    , (error) ->


export checkingToCall = (employment_id) ->
  type: CHECKING_TO_CALL
  employment_id: employment_id


export changedToCall = (to_call, unchecked, checked_today) ->
  type: CHANGED_TO_CALL
  to_call: to_call
  unchecked: unchecked
  checked_today: checked_today


export destroyToCall = (employment_id) ->
  (dispatch, getState) ->
    UserRequest.delete(getState().session?.token, '/to_call/' + employment_id).then (response) ->
      dispatch(destroyedToCall(response.body.unchecked, response.body.checked_today))

    , (error) ->


export destroyingToCall = (employment_id) ->
  type: DESTROYING_TO_CALL
  to_call_id: employment_id


export destroyedToCall = (unchecked, checked_today) ->
  type: DESTROYED_TO_CALL
  unchecked: unchecked
  checked_today: checked_today
