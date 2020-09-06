/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
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

export var loadFavoritePeople = () => (dispatch, getState) =>
  UserRequest.get(getState, 'favorites/people').then(
    function(response) {
      dispatch(addPeople(response.body.people));
      dispatch(addEmployments(response.body.employments));
      dispatch(addContacts(response.body.external_contacts));
      return dispatch(loadedFavoritePeople(response.body.favorite_people));
    },

    function(error) {}
  );

export var loadFavoriteUnits = () => (dispatch, getState) =>
  UserRequest.get(getState, 'favorites/units').then(
    function(response) {
      dispatch(addUnits(response.body.units));
      return dispatch(loadedFavoriteUnits(response.body.favorite_units));
    },

    function(error) {}
  );

export var loadedFavoritePeople = favorite_people => ({
  type: LOADED_FAVORITE_PEOPLE,
  favorite_people
});

export var loadedFavoriteUnits = favorite_units => ({
  type: LOADED_FAVORITE_UNITS,
  favorite_units
});

export var addFavoriteEmployment = employment_id =>
  function(dispatch, getState) {
    const state = getState();
    dispatch(addingFavoriteEmployment(state.employments[employment_id]));
    return UserRequest.post(
      getState,
      `favorites/people/employments/${employment_id}`
    ).then(
      response => dispatch(loadedFavoritePeople(response.body.favorite_people)),

      function(error) {}
    );
  };

export var addFavoriteContact = contact_id =>
  function(dispatch, getState) {
    const state = getState();
    dispatch(addingFavoriteContact(state.contacts[contact_id]));
    return UserRequest.post(
      getState,
      `favorites/people/contacts/${contact_id}`
    ).then(
      response => dispatch(loadedFavoritePeople(response.body.favorite_people)),

      function(error) {}
    );
  };

export var addingFavoriteEmployment = employment => ({
  type: ADDING_FAVORITE_EMPLOYMENT,
  employment
});

export var addingFavoriteContact = contact => ({
  type: ADDING_FAVORITE_CONTACT,
  contact
});

export var addFavoriteUnit = unit_id =>
  function(dispatch, getState) {
    const state = getState();
    dispatch(addingFavoriteUnit(state.units[unit_id]));
    return UserRequest.post(getState, `favorites/units/${unit_id}`).then(
      response => dispatch(loadedFavoriteUnits(response.body.favorite_units)),

      function(error) {}
    );
  };

export var addingFavoriteUnit = unit => ({
  type: ADDING_FAVORITE_UNIT,
  unit
});

export var removeFavoriteEmployment = employment_id =>
  function(dispatch, getState) {
    dispatch(removingFavoriteEmployment(employment_id));
    return UserRequest.delete(
      getState,
      `favorites/people/employments/${employment_id}`
    ).then(
      response => dispatch(loadedFavoritePeople(response.body.favorite_people)),

      function(error) {}
    );
  };

export var removeFavoriteContact = contact_id =>
  function(dispatch, getState) {
    dispatch(removingFavoriteContact(contact_id));
    return UserRequest.delete(
      getState,
      `favorites/people/contacts/${contact_id}`
    ).then(
      response => dispatch(loadedFavoritePeople(response.body.favorite_people)),

      function(error) {}
    );
  };

export var removingFavoriteEmployment = employment_id => ({
  type: REMOVING_FAVORITE_EMPLOYMENT,
  employment_id
});

export var removingFavoriteContact = contact_id => ({
  type: REMOVING_FAVORITE_CONTACT,
  contact_id
});

export var removeFavoriteUnit = unit_id =>
  function(dispatch, getState) {
    dispatch(removingFavoriteUnit(unit_id));
    return UserRequest.delete(getState, `favorites/units/${unit_id}`).then(
      response => dispatch(loadedFavoriteUnits(response.body.favorite_units)),

      function(error) {}
    );
  };

export var removingFavoriteUnit = unit_id => ({
  type: REMOVING_FAVORITE_UNIT,
  unit_id
});

export var showFavoriteEmployments = () => ({
  type: SHOW_FAVORITE_PEOPLE
});

export var showFavoriteUnits = () => ({
  type: SHOW_FAVORITE_UNITS
});
