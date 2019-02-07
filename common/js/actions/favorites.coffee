import { UserRequest } from '@lib/request'

import { addPeople } from '@actions/people'
import { addEmployments } from '@actions/employments'

import {
  LOADED_FAVORITES
  ADDING_FAVORITE_EMPLOYMENT
  ADDING_FAVORITE_UNIT
  REMOVING_FAVORITE_EMPLOYMENT
  REMOVING_FAVORITE_UNIT
  CHANGED_FAVORITE_EMPLOYMENTS
  CHANGED_FAVORITE_UNITS
  SHOW_FAVORITE_EMPLOYMENTS
  SHOW_FAVORITE_UNITS
} from '@constants/favorites'


export loadFavorites = ->
  (dispatch, getState) ->
    UserRequest.get(getState().session?.token, '/favorites').then (response) ->
      if response.body.people?
        dispatch(addPeople(response.body.people))
      if response.body.employments?
        dispatch(addEmployments(response.body.employments))
      dispatch(loadedFavorites(response.body.employment_ids, response.body.unit_ids))

    , (error) ->


export loadedFavorites = (employment_ids, unit_ids) ->
  type: LOADED_FAVORITES
  employment_ids: employment_ids
  unit_ids: unit_ids


export addFavoriteEmployment = (employment_id) ->
  (dispatch, getState) ->
    state = getState()
    dispatch(addingFavoriteEmployment(employment_id, state.employments, state.people))
    UserRequest.post(getState().session?.token, "/favorites/employment/#{employment_id}").then (response) ->
      dispatch(changedFavoriteEmployment(response.body.employment_ids))

    , (error) ->


export addingFavoriteEmployment = (employment_id, employments, people) ->
  type: ADDING_FAVORITE_EMPLOYMENT
  employment_id: employment_id
  employments: employments
  people: people


export addFavoriteUnit = (unit_id) ->
  (dispatch, getState) ->
    dispatch(addingFavoriteUnit(unit_id))
    UserRequest.post(getState().session?.token, "/favorites/unit/#{unit_id}").then (response) ->
      dispatch(changedFavoriteUnit(response.body.unit_ids))

    , (error) ->


export addingFavoriteUnit = (unit_id) ->
  type: ADDING_FAVORITE_UNIT
  unit_id: unit_id


export removeFavoriteEmployment = (employment_id) ->
  (dispatch, getState) ->
    dispatch(removingFavoriteEmployment(employment_id))
    UserRequest.delete(getState().session?.token, "/favorites/employment/#{employment_id}").then (response) ->
      dispatch(changedFavoriteEmployment(response.body.employment_ids))

    , (error) ->


export removingFavoriteEmployment = (employment_id) ->
  type: REMOVING_FAVORITE_EMPLOYMENT
  employment_id: employment_id


export removeFavoriteUnit = (unit_id) ->
  (dispatch, getState) ->
    dispatch(removingFavoriteUnit(unit_id))
    UserRequest.delete(getState().session?.token, "/favorites/unit/#{unit_id}").then (response) ->
      dispatch(changedFavoriteUnit(response.body.unit_ids))

    , (error) ->


export removingFavoriteUnit = (unit_id) ->
  type: REMOVING_FAVORITE_UNIT
  unit_id: unit_id


export changedFavoriteEmployment = (employment_ids) ->
  type: CHANGED_FAVORITE_EMPLOYMENTS
  employment_ids: employment_ids


export changedFavoriteUnit = (unit_ids) ->
  type: CHANGED_FAVORITE_UNITS
  unit_ids: unit_ids


export showFavoriteEmployments = ->
  type: SHOW_FAVORITE_EMPLOYMENTS


export showFavoriteUnits = ->
  type: SHOW_FAVORITE_UNITS
