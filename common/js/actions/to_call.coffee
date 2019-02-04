import { Request } from '@lib/request'

import {
  LOADED_TO_CALL
  ADDING_TO_CALL
  CHECKING_TO_CALL
  CHANGED_TO_CALL
  DESTROYING_TO_CALL
  DESTROYED_TO_CALL
} from '@constants/to_call'


export loadedToCall = (to_call_arr) ->
  type: LOADED_TO_CALL
  to_call_arr: to_call_arr


export addToCall = (employment_id) ->
  (dispatch, getState) ->
    dispatch(addingToCall(employment_id))
    Request.post('/to_call/' + employment_id).then (response) ->
      dispatch(changedToCall(response.body.to_call, response.body.checked, response.body.unchecked))

    , (error) ->


export addingToCall = (employment_id) ->
  type: ADDING_TO_CALL
  employment_id: employment_id


export checkToCall = (employment_id) ->
  (dispatch, getState) ->
    dispatch(checkingToCall(employment_id))
    Request.post('/to_call/' + employment_id + '/check').then (response) ->
      dispatch(changedToCall(response.body.to_call, response.body.checked, response.body.unchecked))

    , (error) ->


export checkingToCall = (employment_id) ->
  type: CHECKING_TO_CALL
  employment_id: employment_id


export changedToCall = (to_call, unchecked, checked) ->
  type: CHANGED_TO_CALL
  to_call: to_call
  unchecked: unchecked
  checked: checked


export destroyToCall = (to_call_id) ->
  (dispatch, getState) ->
    Request.delete('/to_call/' + to_call_id).then (response) ->

    , (error) ->


export destroyingToCall = (to_call_id) ->
  type: DESTROYING_TO_CALL
  to_call_id: to_call_id


export destroyedToCall = (to_call_id) ->
  type: DESTROYED_TO_CALL
  to_call_id: to_call_id
