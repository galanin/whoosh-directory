import { Request } from '@lib/request'

import {
  SEND_QUERY
  SET_CURRENT_RESULTS
  SET_HUMAN_QUERY
  SET_MACHINE_QUERY
  SET_RESULTS_TYPE
  SET_RESULTS_SOURCE
} from '@constants/search'


import { addUnitTitles } from '@actions/unit_titles'
import { addPeople } from '@actions/people'
import { addEmployments } from '@actions/employments'
import { addContacts } from '@actions/contacts'
import { popSearchResults } from '@actions/layout'
import {
  setSearchRunning
  setSearchFinished
  hasQuerySent
  hasQueryFinished
  getCachedQueryType
  getCachedQueryResults
  getCachedQueryBirthdays
  getCachedQueryBirthdayInterval
} from '@actions/search_cache'
import { setBirthdayPeriodByInterval } from '@actions/birthday_period'
import { setBirthdayResults } from '@actions/birthdays'


export setQuery = (query_string) ->
  type: SET_HUMAN_QUERY
  query: query_string


export setMachineQuery = (query_string) ->
  type: SET_MACHINE_QUERY
  query: query_string


# RESULTS_SOURCE_* -> 'birthday' or 'query'
export setResultsSource = (results_source) ->
  type: SET_RESULTS_SOURCE
  results_source: results_source


# 'birthday' or 'common'
export setResultsType = (results_type) ->
  type: SET_RESULTS_TYPE
  results_type: results_type


isCurrentMachineQuery = (getState, query) ->
  query == getState().search.current_machine_query


export forceQueryResults = ->
  (dispatch, getState) ->
    dispatch(fetchQueryResults(getState().search.current_machine_query))


export fetchQueryResults = (machine_query_string) ->
  (dispatch, getState) ->
    if hasQuerySent(getState, machine_query_string)
      if hasQueryFinished(getState, machine_query_string)
        # fetch from the cache
        dispatch(setResultsType(getCachedQueryType(getState, machine_query_string)))

        results = getCachedQueryResults(getState, machine_query_string)
        if results?
          dispatch(setCurrentResults(results))

        birthdays = getCachedQueryBirthdays(getState, machine_query_string)
        if birthdays?
          dispatch(setBirthdayResults(birthdays))

        birthday_interval = getCachedQueryBirthdayInterval(getState, machine_query_string)
        if birthday_interval?
          dispatch(setBirthdayPeriodByInterval(...birthday_interval))
      else
        # do nothing, wait until a query has finished
    else
      # send a real query
      dispatch(sendQuery(machine_query_string))


export sendQuery = (machine_query_string) ->
  (dispatch, getState) ->
    dispatch(setSearchRunning(machine_query_string))
    Request.get('/search').query(q: machine_query_string).then (response) ->
      dispatch(setSearchFinished(machine_query_string, response.body.type, response.body.results, response.body.birthday_interval, response.body.birthdays))

      dispatch(setResultsType(response.body.type))

      if response.body.people?
        dispatch(addPeople(response.body.people))
      if response.body.employments?
        dispatch(addEmployments(response.body.employments))
      if response.body.external_contacts?
        dispatch(addContacts(response.body.external_contacts))
      if response.body.unit_titles?
        dispatch(addUnitTitles(response.body.unit_titles))

      if isCurrentMachineQuery(getState, response.body.query)
        if response.body.results?
          dispatch(setCurrentResults(response.body.results))
        if response.body.birthday_interval?
          dispatch(setBirthdayPeriodByInterval(...response.body.birthday_interval))

      if response.body.birthdays?
        dispatch(setBirthdayResults(response.body.birthdays))

    , (error) ->


export setCurrentResults = (results) ->
  type: SET_CURRENT_RESULTS
  results: results
