import {
  FETCH_INITIAL_STATE_REQUEST,
  FETCH_INITIAL_STATE_SUCCESS,
  FETCH_INITIAL_STATE_FAILURE
} from '@constants/initial_state'
import api from '@lib/api'
import generateActionCreator from '@lib/generateActionCreator'
import { setUnits } from '@actions/units'
import { setExpandedUnits } from '@actions/expand_units'


export fetchInitialStateRequest = generateActionCreator(FETCH_INITIAL_STATE_REQUEST)
export fetchInitialStateSuccess = generateActionCreator(FETCH_INITIAL_STATE_SUCCESS)
export fetchInitialStateFailure = generateActionCreator(FETCH_INITIAL_STATE_FAILURE, 'error')

export fetchInitialState = () ->
  (dispatch) ->
    dispatch(fetchInitialStateRequest())

    api
      .get '/api/bootstrap'
      .then (data) ->
        dispatch(fetchInitialStateSuccess())
        dispatch(setUnits(data.data.organization_units))
        dispatch(setExpandedUnits(data.data.expanded_units))

        Promise.resolve(data)
      .catch (error) ->
        dispatch(fetchInitialStateFailure(error))

        Promise.resolve(error)
