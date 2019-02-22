import { UserRequest } from '@lib/request'

import {
  LOADED_TO_CALL
  ADDING_EMPLOYMENT_TO_CALL
  ADDING_CONTACT_TO_CALL
  CHECKING_EMPLOYMENT_TO_CALL
  CHECKING_CONTACT_TO_CALL
  CHANGED_TO_CALL
  DESTROYING_EMPLOYMENT_TO_CALL
  DESTROYING_CONTACT_TO_CALL
  DESTROYED_TO_CALL
} from '@constants/to_call'

import { addPeople } from '@actions/people'
import { addEmployments } from '@actions/employments'
import { addContacts } from '@actions/contacts'


export loadToCall = ->
  (dispatch, getState) ->
    UserRequest.get(getState().session?.token, '/to_call').then (response) ->
      dispatch(loadedToCall(response.body.data, response.body.unchecked, response.body.checked_today))
      if response.body.people?
        dispatch(addPeople(response.body.people))
      if response.body.employments?
        dispatch(addEmployments(response.body.employments))
      if response.body.contacts?
        dispatch(addContacts(response.body.contacts))

    , (error) ->


export loadedToCall = (data, unchecked, checked_today) ->
  type: LOADED_TO_CALL
  data: data
  unchecked: unchecked
  checked_today: checked_today


export addEmploymentToCall = (employment_id) ->
  (dispatch, getState) ->
    dispatch(addingEmploymentToCall(employment_id))
    UserRequest.post(getState().session?.token, '/to_call/employment/' + employment_id).then (response) ->
      dispatch(changedToCall(response.body.to_call, response.body.unchecked, response.body.checked_today))

    , (error) ->


export addContactToCall = (contact_id) ->
  (dispatch, getState) ->
    dispatch(addingContactToCall(contact_id))
    UserRequest.post(getState().session?.token, '/to_call/contact/' + contact_id).then (response) ->
      dispatch(changedToCall(response.body.to_call, response.body.unchecked, response.body.checked_today))

    , (error) ->


export addingEmploymentToCall = (employment_id) ->
  type: ADDING_EMPLOYMENT_TO_CALL
  employment_id: employment_id


export addingContactToCall = (contact_id) ->
  type: ADDING_CONTACT_TO_CALL
  contact_id: contact_id


export checkEmploymentToCall = (employment_id) ->
  (dispatch, getState) ->
    dispatch(checkingEmploymentToCall(employment_id))
    UserRequest.post(getState().session?.token, '/to_call/employment/' + employment_id + '/check').then (response) ->
      dispatch(changedToCall(response.body.to_call, response.body.unchecked, response.body.checked_today))

    , (error) ->


export checkContactToCall = (contact_id) ->
  (dispatch, getState) ->
    dispatch(checkingContactToCall(contact_id))
    UserRequest.post(getState().session?.token, '/to_call/contact/' + contact_id + '/check').then (response) ->
      dispatch(changedToCall(response.body.to_call, response.body.unchecked, response.body.checked_today))

    , (error) ->


export checkingEmploymentToCall = (employment_id) ->
  type: CHECKING_EMPLOYMENT_TO_CALL
  employment_id: employment_id


export checkingContactToCall = (contact_id) ->
  type: CHECKING_CONTACT_TO_CALL
  contact_id: contact_id


export changedToCall = (to_call, unchecked, checked_today) ->
  type: CHANGED_TO_CALL
  to_call: to_call
  unchecked: unchecked
  checked_today: checked_today


export destroyEmploymentToCall = (employment_id) ->
  (dispatch, getState) ->
    dispatch(destroyingEmploymentToCall(employment_id))
    UserRequest.delete(getState().session?.token, '/to_call/employment/' + employment_id).then (response) ->
      dispatch(destroyedToCall(response.body.unchecked, response.body.checked_today))

    , (error) ->


export destroyContactToCall = (contact_id) ->
  (dispatch, getState) ->
    dispatch(destroyingContactToCall(contact_id))
    UserRequest.delete(getState().session?.token, '/to_call/contact/' + contact_id).then (response) ->
      dispatch(destroyedToCall(response.body.unchecked, response.body.checked_today))

    , (error) ->


export destroyingEmploymentToCall = (employment_id) ->
  type: DESTROYING_EMPLOYMENT_TO_CALL
  employment_id: employment_id


export destroyingContactToCall = (contact_id) ->
  type: DESTROYING_CONTACT_TO_CALL
  contact_id: contact_id


export destroyedToCall = (unchecked, checked_today) ->
  type: DESTROYED_TO_CALL
  unchecked: unchecked
  checked_today: checked_today
