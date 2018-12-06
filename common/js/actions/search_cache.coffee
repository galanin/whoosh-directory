import {
  SET_SEARCH_RUNNING
  SET_SEARCH_FINISHED
} from '@constants/search_cache'


export setSearchRunning = (query) ->
  type: SET_SEARCH_RUNNING
  query: query


export setSearchFinished = (query, results) ->
  type: SET_SEARCH_FINISHED
  query: query
  results: results


export hasQuerySent = (getState, machine_query_string) ->
  getState().search_cache.hasOwnProperty(machine_query_string)


export hasQueryFinished = (getState, machine_query_string) ->
  getState().search_cache[machine_query_string]?


export getQueryResult = (getState, machine_query_string) ->
  getState().search_cache[machine_query_string]

