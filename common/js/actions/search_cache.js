/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import {
  SET_SEARCH_RUNNING,
  SET_SEARCH_FINISHED
} from '@constants/search_cache';


export var setSearchRunning = query => ({
  type: SET_SEARCH_RUNNING,
  query
});


export var setSearchFinished = (query, type, results, birthday_interval, birthdays) => ({
  type: SET_SEARCH_FINISHED,
  query,
  search_type: type,
  results,
  birthday_interval,
  birthdays
});


export var hasQuerySent = (getState, machine_query_string) => getState().search_cache.hasOwnProperty(machine_query_string);


export var hasQueryFinished = (getState, machine_query_string) => getState().search_cache[machine_query_string] != null;


export var getCachedQueryType = (getState, machine_query_string) => getState().search_cache[machine_query_string].type;


export var getCachedQueryResults = (getState, machine_query_string) => getState().search_cache[machine_query_string].results;


export var getCachedQueryBirthdays = (getState, machine_query_string) => getState().search_cache[machine_query_string].birthdays;


export var getCachedQueryBirthdayInterval = (getState, machine_query_string) => getState().search_cache[machine_query_string].birthday_interval;
