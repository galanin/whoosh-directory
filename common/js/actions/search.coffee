import {Request} from '@lib/request'

import {
  SEND_QUERY
  SET_CURRENT_RESULTS
  SET_HUMAN_QUERY
  SET_MACHINE_QUERY
} from '@constants/search'


import { addUnitTitles } from '@actions/unit_titles'
import { addPeople } from '@actions/people'
import { addEmployments } from '@actions/employments'
import { addContacts } from '@actions/contacts'
import { popSearchResults } from '@actions/layout'
import { setSearchRunning, setSearchFinished, hasQuerySent, hasQueryFinished, getQueryResult } from '@actions/search_cache'


normalizeWhitespace = (string) ->
  string.replace(/\s+/, ' ').trim()


export setQuery = (query_string) ->
  (dispatch, getState) ->
    dispatch(setHumanQuery(query_string))

    machine_query_string = normalizeWhitespace(query_string)
    dispatch(setMachineQuery(machine_query_string))
    if machine_query_string == ''
      dispatch(setCurrentResults({}))
    else
      dispatch(getQueryResults(machine_query_string))


export setHumanQuery = (query_string) ->
  type: SET_HUMAN_QUERY
  query: query_string


export setMachineQuery = (query_string) ->
  type: SET_MACHINE_QUERY
  query: query_string


isCurrentMachineQuery = (getState, query) ->
  query == getState().search.current_machine_query


export getQueryResults = (machine_query_string) ->
  (dispatch, getState) ->
    if hasQuerySent(getState, machine_query_string)
      if hasQueryFinished(getState, machine_query_string)
        dispatch(setCurrentResults(getQueryResult(getState, machine_query_string)))
      else
        # do nothing, wait until query finished
    else
      dispatch(sendQuery(machine_query_string))


export sendQuery = (machine_query_string) ->
  (dispatch, getState) ->
    dispatch(setSearchRunning(machine_query_string))
    Request.get('/search').query(q: machine_query_string).then (response) ->
      dispatch(setSearchFinished(machine_query_string, response.body.results))
      if response.body.people?
        dispatch(addPeople(response.body.people))
      if response.body.employments?
        dispatch(addEmployments(response.body.employments))
      if response.body.external_contacts?
        dispatch(addContacts(response.body.external_contacts))
      if response.body.unit_titles?
        dispatch(addUnitTitles(response.body.unit_titles))

      if isCurrentMachineQuery(getState, response.body.query)
        dispatch(setCurrentResults(response.body.results))

    , (error) ->


export setCurrentResults = (results) ->
  type: SET_CURRENT_RESULTS
  results: results
