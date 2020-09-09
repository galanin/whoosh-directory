import { UserRequest } from '@lib/request';

import { addPeople } from '@actions/people';
import { addEmployments } from '@actions/employments';
import { addUnits } from '@actions/units';
import { addContacts } from '@actions/contacts';

import {
  LOADED_FAVORITE_PEOPLE,
  LOADED_FAVORITE_UNITS,
  ADDING_FAVORITE_EMPLOYMENT,
  ADDING_FAVORITE_CONTACT,
  ADDING_FAVORITE_UNIT,
  REMOVING_FAVORITE_EMPLOYMENT,
  REMOVING_FAVORITE_CONTACT,
  REMOVING_FAVORITE_UNIT,
  SHOW_FAVORITE_PEOPLE,
  SHOW_FAVORITE_UNITS
} from '@constants/favorites';

export const loadFavoritePeople = () => (dispatch, getState) =>
  UserRequest.get(getState, 'favorites/people').then(
    response => {
      dispatch(addPeople(response.body.people));
      dispatch(addEmployments(response.body.employments));
      dispatch(addContacts(response.body.external_contacts));
      return dispatch(loadedFavoritePeople(response.body.favorite_people));
    },

    error => {}
  );

export const loadFavoriteUnits = () => (dispatch, getState) =>
  UserRequest.get(getState, 'favorites/units').then(
    response => {
      dispatch(addUnits(response.body.units));
      return dispatch(loadedFavoriteUnits(response.body.favorite_units));
    },

    error => {}
  );

export const loadedFavoritePeople = favorite_people => ({
  type: LOADED_FAVORITE_PEOPLE,
  favorite_people
});

export const loadedFavoriteUnits = favorite_units => ({
  type: LOADED_FAVORITE_UNITS,
  favorite_units
});

export const addFavoriteEmployment = employment_id => (dispatch, getState) => {
  const state = getState();
  dispatch(addingFavoriteEmployment(state.employments[employment_id]));
  return UserRequest.post(
    getState,
    `favorites/people/employments/${employment_id}`
  ).then(
    response => dispatch(loadedFavoritePeople(response.body.favorite_people)),

    error => {}
  );
};

export const addFavoriteContact = contact_id => (dispatch, getState) => {
  const state = getState();
  dispatch(addingFavoriteContact(state.contacts[contact_id]));
  return UserRequest.post(
    getState,
    `favorites/people/contacts/${contact_id}`
  ).then(
    response => dispatch(loadedFavoritePeople(response.body.favorite_people)),

    error => {}
  );
};

export const addingFavoriteEmployment = employment => ({
  type: ADDING_FAVORITE_EMPLOYMENT,
  employment
});

export const addingFavoriteContact = contact => ({
  type: ADDING_FAVORITE_CONTACT,
  contact
});

export const addFavoriteUnit = unit_id => (dispatch, getState) => {
  const state = getState();
  dispatch(addingFavoriteUnit(state.units[unit_id]));
  return UserRequest.post(getState, `favorites/units/${unit_id}`).then(
    response => dispatch(loadedFavoriteUnits(response.body.favorite_units)),

    function(error) {}
  );
};

export const addingFavoriteUnit = unit => ({
  type: ADDING_FAVORITE_UNIT,
  unit
});

export const removeFavoriteEmployment = employment_id => (
  dispatch,
  getState
) => {
  dispatch(removingFavoriteEmployment(employment_id));
  return UserRequest.delete(
    getState,
    `favorites/people/employments/${employment_id}`
  ).then(
    response => dispatch(loadedFavoritePeople(response.body.favorite_people)),

    error => {}
  );
};

export const removeFavoriteContact = contact_id => (dispatch, getState) => {
  dispatch(removingFavoriteContact(contact_id));
  return UserRequest.delete(
    getState,
    `favorites/people/contacts/${contact_id}`
  ).then(
    response => dispatch(loadedFavoritePeople(response.body.favorite_people)),

    error => {}
  );
};

export const removingFavoriteEmployment = employment_id => ({
  type: REMOVING_FAVORITE_EMPLOYMENT,
  employment_id
});

export const removingFavoriteContact = contact_id => ({
  type: REMOVING_FAVORITE_CONTACT,
  contact_id
});

export const removeFavoriteUnit = unit_id => (dispatch, getState) => {
  dispatch(removingFavoriteUnit(unit_id));
  return UserRequest.delete(getState, `favorites/units/${unit_id}`).then(
    response => dispatch(loadedFavoriteUnits(response.body.favorite_units)),

    error => {}
  );
};

export const removingFavoriteUnit = unit_id => ({
  type: REMOVING_FAVORITE_UNIT,
  unit_id
});

export const showFavoriteEmployments = () => ({
  type: SHOW_FAVORITE_PEOPLE
});

export const showFavoriteUnits = () => ({
  type: SHOW_FAVORITE_UNITS
});
