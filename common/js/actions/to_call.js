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

export const loadToCall = () => (dispatch, getState) =>
  UserRequest.get(getState, 'to_call').then(
    response => {
      dispatch(
        loadedToCall(
          response.body.data,
          response.body.unchecked,
          response.body.checked_today
        )
      );
      if (response.body.people != null) {
        dispatch(addPeople(response.body.people));
      }
      if (response.body.employments != null) {
        dispatch(addEmployments(response.body.employments));
      }
      if (response.body.contacts != null) {
        return dispatch(addContacts(response.body.contacts));
      }
    },

    error => {}
  );

export const loadedToCall = (data, unchecked, checked_today) => ({
  type: LOADED_TO_CALL,
  data,
  unchecked,
  checked_today
});

export const addEmploymentToCall = employment_id => (dispatch, getState) => {
  dispatch(addingEmploymentToCall(employment_id));
  return UserRequest.post(getState, 'to_call/employment/' + employment_id).then(
    response =>
      dispatch(
        changedToCall(
          response.body.to_call,
          response.body.unchecked,
          response.body.checked_today
        )
      ),

    error => {}
  );
};

export const addContactToCall = contact_id => (dispatch, getState) => {
  dispatch(addingContactToCall(contact_id));
  return UserRequest.post(getState, 'to_call/contact/' + contact_id).then(
    response =>
      dispatch(
        changedToCall(
          response.body.to_call,
          response.body.unchecked,
          response.body.checked_today
        )
      ),

    error => {}
  );
};

export const addingEmploymentToCall = employment_id => ({
  type: ADDING_EMPLOYMENT_TO_CALL,
  employment_id
});

export const addingContactToCall = contact_id => ({
  type: ADDING_CONTACT_TO_CALL,
  contact_id
});

export const checkEmploymentToCall = employment_id => (dispatch, getState) => {
  dispatch(checkingEmploymentToCall(employment_id));
  return UserRequest.post(
    getState,
    'to_call/employment/' + employment_id + '/check'
  ).then(
    response =>
      dispatch(
        changedToCall(
          response.body.to_call,
          response.body.unchecked,
          response.body.checked_today
        )
      ),

    error => {}
  );
};

export const checkContactToCall = contact_id => (dispatch, getState) => {
  dispatch(checkingContactToCall(contact_id));
  return UserRequest.post(
    getState,
    'to_call/contact/' + contact_id + '/check'
  ).then(
    response =>
      dispatch(
        changedToCall(
          response.body.to_call,
          response.body.unchecked,
          response.body.checked_today
        )
      ),

    error => {}
  );
};

export const checkingEmploymentToCall = employment_id => ({
  type: CHECKING_EMPLOYMENT_TO_CALL,
  employment_id
});

export const checkingContactToCall = contact_id => ({
  type: CHECKING_CONTACT_TO_CALL,
  contact_id
});

export const changedToCall = (to_call, unchecked, checked_today) => ({
  type: CHANGED_TO_CALL,
  to_call,
  unchecked,
  checked_today
});

export const destroyEmploymentToCall = employment_id => (
  dispatch,
  getState
) => {
  dispatch(destroyingEmploymentToCall(employment_id));
  return UserRequest.delete(
    getState,
    'to_call/employment/' + employment_id
  ).then(
    response =>
      dispatch(
        destroyedToCall(response.body.unchecked, response.body.checked_today)
      ),

    error => {}
  );
};

export const destroyContactToCall = contact_id => (dispatch, getState) => {
  dispatch(destroyingContactToCall(contact_id));
  return UserRequest.delete(getState, 'to_call/contact/' + contact_id).then(
    response =>
      dispatch(
        destroyedToCall(response.body.unchecked, response.body.checked_today)
      ),

    error => {}
  );
};

export const destroyingEmploymentToCall = employment_id => ({
  type: DESTROYING_EMPLOYMENT_TO_CALL,
  employment_id
});

export const destroyingContactToCall = contact_id => ({
  type: DESTROYING_CONTACT_TO_CALL,
  contact_id
});

export const destroyedToCall = (unchecked, checked_today) => ({
  type: DESTROYED_TO_CALL,
  unchecked,
  checked_today
});
