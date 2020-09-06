/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import { UserRequest } from '@lib/request';

import {
  LOADED_TO_CALL,
  ADDING_EMPLOYMENT_TO_CALL,
  ADDING_CONTACT_TO_CALL,
  CHECKING_EMPLOYMENT_TO_CALL,
  CHECKING_CONTACT_TO_CALL,
  CHANGED_TO_CALL,
  DESTROYING_EMPLOYMENT_TO_CALL,
  DESTROYING_CONTACT_TO_CALL,
  DESTROYED_TO_CALL
} from '@constants/to_call';

import { addPeople } from '@actions/people';
import { addEmployments } from '@actions/employments';
import { addContacts } from '@actions/contacts';


export var loadToCall = () => (dispatch, getState) => UserRequest.get(getState, 'to_call').then(function(response) {
  dispatch(loadedToCall(response.body.data, response.body.unchecked, response.body.checked_today));
  if (response.body.people != null) {
    dispatch(addPeople(response.body.people));
  }
  if (response.body.employments != null) {
    dispatch(addEmployments(response.body.employments));
  }
  if (response.body.contacts != null) {
    return dispatch(addContacts(response.body.contacts));
  }
}

  , function(error) {});


export var loadedToCall = (data, unchecked, checked_today) => ({
  type: LOADED_TO_CALL,
  data,
  unchecked,
  checked_today
});


export var addEmploymentToCall = employment_id => (function(dispatch, getState) {
  dispatch(addingEmploymentToCall(employment_id));
  return UserRequest.post(getState, 'to_call/employment/' + employment_id).then(response => dispatch(changedToCall(response.body.to_call, response.body.unchecked, response.body.checked_today))

    , function(error) {});
});


export var addContactToCall = contact_id => (function(dispatch, getState) {
  dispatch(addingContactToCall(contact_id));
  return UserRequest.post(getState, 'to_call/contact/' + contact_id).then(response => dispatch(changedToCall(response.body.to_call, response.body.unchecked, response.body.checked_today))

    , function(error) {});
});


export var addingEmploymentToCall = employment_id => ({
  type: ADDING_EMPLOYMENT_TO_CALL,
  employment_id
});


export var addingContactToCall = contact_id => ({
  type: ADDING_CONTACT_TO_CALL,
  contact_id
});


export var checkEmploymentToCall = employment_id => (function(dispatch, getState) {
  dispatch(checkingEmploymentToCall(employment_id));
  return UserRequest.post(getState, 'to_call/employment/' + employment_id + '/check').then(response => dispatch(changedToCall(response.body.to_call, response.body.unchecked, response.body.checked_today))

    , function(error) {});
});


export var checkContactToCall = contact_id => (function(dispatch, getState) {
  dispatch(checkingContactToCall(contact_id));
  return UserRequest.post(getState, 'to_call/contact/' + contact_id + '/check').then(response => dispatch(changedToCall(response.body.to_call, response.body.unchecked, response.body.checked_today))

    , function(error) {});
});


export var checkingEmploymentToCall = employment_id => ({
  type: CHECKING_EMPLOYMENT_TO_CALL,
  employment_id
});


export var checkingContactToCall = contact_id => ({
  type: CHECKING_CONTACT_TO_CALL,
  contact_id
});


export var changedToCall = (to_call, unchecked, checked_today) => ({
  type: CHANGED_TO_CALL,
  to_call,
  unchecked,
  checked_today
});


export var destroyEmploymentToCall = employment_id => (function(dispatch, getState) {
  dispatch(destroyingEmploymentToCall(employment_id));
  return UserRequest.delete(getState, 'to_call/employment/' + employment_id).then(response => dispatch(destroyedToCall(response.body.unchecked, response.body.checked_today))

    , function(error) {});
});


export var destroyContactToCall = contact_id => (function(dispatch, getState) {
  dispatch(destroyingContactToCall(contact_id));
  return UserRequest.delete(getState, 'to_call/contact/' + contact_id).then(response => dispatch(destroyedToCall(response.body.unchecked, response.body.checked_today))

    , function(error) {});
});


export var destroyingEmploymentToCall = employment_id => ({
  type: DESTROYING_EMPLOYMENT_TO_CALL,
  employment_id
});


export var destroyingContactToCall = contact_id => ({
  type: DESTROYING_CONTACT_TO_CALL,
  contact_id
});


export var destroyedToCall = (unchecked, checked_today) => ({
  type: DESTROYED_TO_CALL,
  unchecked,
  checked_today
});
