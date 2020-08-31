import { UserRequest } from '@lib/request'

import { addPeople } from '@actions/people'
import { addEmployments } from '@actions/employments'
import { addUnits } from '@actions/units'
import { addContacts } from '@actions/contacts'

import {
  LOADED_FAVORITE_PEOPLE
  LOADED_FAVORITE_UNITS
  ADDING_FAVORITE_EMPLOYMENT
  ADDING_FAVORITE_CONTACT
  ADDING_FAVORITE_UNIT
  REMOVING_FAVORITE_EMPLOYMENT
  REMOVING_FAVORITE_CONTACT
  REMOVING_FAVORITE_UNIT
  SHOW_FAVORITE_PEOPLE
  SHOW_FAVORITE_UNITS
} from '@constants/favorites'


export loadFavoritePeople = ->
  (dispatch, getState) ->
    UserRequest.get(getState, 'favorites/people').then (response) ->
      dispatch(addPeople(response.body.people))
      dispatch(addEmployments(response.body.employments))
      dispatch(addContacts(response.body.external_contacts))
      dispatch(loadedFavoritePeople(response.body.favorite_people))

    , (error) ->


export loadFavoriteUnits = ->
  (dispatch, getState) ->
    UserRequest.get(getState, 'favorites/units').then (response) ->
      dispatch(addUnits(response.body.units))
      dispatch(loadedFavoriteUnits(response.body.favorite_units))

    , (error) ->


export loadedFavoritePeople = (favorite_people) ->
  type: LOADED_FAVORITE_PEOPLE
  favorite_people: favorite_people


export loadedFavoriteUnits = (favorite_units) ->
  type: LOADED_FAVORITE_UNITS
  favorite_units: favorite_units


export addFavoriteEmployment = (employment_id) ->
  (dispatch, getState) ->
    state = getState()
    dispatch(addingFavoriteEmployment(state.employments[employment_id]))
    UserRequest.post(getState, "favorites/people/employments/#{employment_id}").then (response) ->
      dispatch(loadedFavoritePeople(response.body.favorite_people))

    , (error) ->


export addFavoriteContact = (contact_id) ->
  (dispatch, getState) ->
    state = getState()
    dispatch(addingFavoriteContact(state.contacts[contact_id]))
    UserRequest.post(getState, "favorites/people/contacts/#{contact_id}").then (response) ->
      dispatch(loadedFavoritePeople(response.body.favorite_people))

    , (error) ->


export addingFavoriteEmployment = (employment) ->
  type: ADDING_FAVORITE_EMPLOYMENT
  employment: employment


export addingFavoriteContact = (contact) ->
  type: ADDING_FAVORITE_CONTACT
  contact: contact


export addFavoriteUnit = (unit_id) ->
  (dispatch, getState) ->
    state = getState()
    dispatch(addingFavoriteUnit(state.units[unit_id]))
    UserRequest.post(getState, "favorites/units/#{unit_id}").then (response) ->
      dispatch(loadedFavoriteUnits(response.body.favorite_units))

    , (error) ->


export addingFavoriteUnit = (unit) ->
  type: ADDING_FAVORITE_UNIT
  unit: unit


export removeFavoriteEmployment = (employment_id) ->
  (dispatch, getState) ->
    dispatch(removingFavoriteEmployment(employment_id))
    UserRequest.delete(getState, "favorites/people/employments/#{employment_id}").then (response) ->
      dispatch(loadedFavoritePeople(response.body.favorite_people))

    , (error) ->


export removeFavoriteContact = (contact_id) ->
  (dispatch, getState) ->
    dispatch(removingFavoriteContact(contact_id))
    UserRequest.delete(getState, "favorites/people/contacts/#{contact_id}").then (response) ->
      dispatch(loadedFavoritePeople(response.body.favorite_people))

    , (error) ->


export removingFavoriteEmployment = (employment_id) ->
  type: REMOVING_FAVORITE_EMPLOYMENT
  employment_id: employment_id


export removingFavoriteContact = (contact_id) ->
  type: REMOVING_FAVORITE_CONTACT
  contact_id: contact_id


export removeFavoriteUnit = (unit_id) ->
  (dispatch, getState) ->
    dispatch(removingFavoriteUnit(unit_id))
    UserRequest.delete(getState, "favorites/units/#{unit_id}").then (response) ->
      dispatch(loadedFavoriteUnits(response.body.favorite_units))

    , (error) ->


export removingFavoriteUnit = (unit_id) ->
  type: REMOVING_FAVORITE_UNIT
  unit_id: unit_id


export showFavoriteEmployments = ->
  type: SHOW_FAVORITE_PEOPLE


export showFavoriteUnits = ->
  type: SHOW_FAVORITE_UNITS
