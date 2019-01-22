import { isEqual } from 'lodash'

import { LOCATION_CHANGE } from 'connected-react-router'
import { getNewUrlParam } from '@lib/url-parsing'
import { URL_PARAM_RESULTS_SOURCE } from '@constants/url-parsing'

import { unpackResultsSource } from '@lib/search'

import {
  SET_HUMAN_QUERY
  SET_MACHINE_QUERY
  SET_CURRENT_RESULTS
  SET_RESULTS_TYPE
  SET_RESULTS_SOURCE
  DEFAULT_RESULTS_SOURCE
} from '@constants/search'


export default (state = { query: '', current_machine_query: '' }, action) ->
  switch action.type

    when SET_HUMAN_QUERY
      new_state = Object.assign({}, state)
      new_state.query = action.query
      new_state

    when SET_MACHINE_QUERY
      new_state = Object.assign({}, state)
      new_state.current_machine_query = action.query
      new_state

    when SET_CURRENT_RESULTS
      new_state = Object.assign({}, state)
      new_state.results = action.results
      new_state

    when SET_RESULTS_TYPE
      new_state = Object.assign({}, state)
      new_state.results_type = action.results_type
      new_state

    when SET_RESULTS_SOURCE
      new_state = Object.assign({}, state)
      new_state.results_source = action.results_source
      new_state

    when LOCATION_CHANGE
      if action.payload.action == 'POP'
        results_source_packed = getNewUrlParam(action.payload, URL_PARAM_RESULTS_SOURCE)

        new_state = Object.assign({}, state)

        if results_source_packed?
          new_results_source = unpackResultsSource(results_source_packed)
          if isEqual(new_results_source, state.results_source)
            state
          else
            new_state.results_source = new_results_source
        else
          new_state.results_source = DEFAULT_RESULTS_SOURCE

        new_state

      else
        state

    else
      state
