import { Request } from '@lib/request'

import {
  SET_QUERY,
  RESET_QUERY,
  SEND_QUERY,
  SET_RESULTS,
} from '@constants/search'

import { addUnitExtras } from '@actions/unit_extras'
import { addPeople } from '@actions/people'
import { addEmployments } from '@actions/employments'
import { popSearchResults } from '@actions/layout'


export setQuery = (query_string) ->
  type: SET_QUERY
  query: query_string

export resetQuery = () ->
  type: RESET_QUERY


export sendQuery = (query_string) ->
  (dispatch, getState) ->

    Request.get('/search').query({q: query_string}).then (response) ->
      console.log response.body
      state = getState()
      console.log state.search
      if response.body.query == state.search.query
        dispatch(addUnitExtras(response.body.unit_extras))
        dispatch(addPeople(response.body.people))
        dispatch(addEmployments(response.body.employments))
        dispatch(setResults(response.body.results))
        dispatch(popSearchResults())
    , (error) ->


export setResults = (results) ->
  type: SET_RESULTS
  results: results
