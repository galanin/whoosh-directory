import {
  SET_SEARCH_RUNNING
  SET_SEARCH_FINISHED
} from '@constants/search_cache'


export setSearchRunning = (query) ->
  type: SET_SEARCH_RUNNING
  query: query


export setSearchFinished = (query, type, results, birthday_interval, birthdays) ->
  type: SET_SEARCH_FINISHED
  query: query
  search_type: type
  results: results
  birthday_interval: birthday_interval
  birthdays: birthdays


export hasQuerySent = (getState, machine_query_string) ->
  getState().search_cache.hasOwnProperty(machine_query_string)


export hasQueryFinished = (getState, machine_query_string) ->
  getState().search_cache[machine_query_string]?


export getCachedQueryType = (getState, machine_query_string) ->
  getState().search_cache[machine_query_string].type


export getCachedQueryResults = (getState, machine_query_string) ->
  getState().search_cache[machine_query_string].results


export getCachedQueryBirthdays = (getState, machine_query_string) ->
  getState().search_cache[machine_query_string].birthdays


export getCachedQueryBirthdayInterval = (getState, machine_query_string) ->
  getState().search_cache[machine_query_string].birthday_interval
