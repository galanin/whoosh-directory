import {
  SET_SEARCH_RUNNING,
  SET_SEARCH_FINISHED
} from '@constants/search_cache';

export const setSearchRunning = query => ({
  type: SET_SEARCH_RUNNING,
  query
});

export const setSearchFinished = (
  query,
  type,
  results,
  birthday_interval,
  birthdays
) => ({
  type: SET_SEARCH_FINISHED,
  query,
  search_type: type,
  results,
  birthday_interval,
  birthdays
});

export const hasQuerySent = (getState, machine_query_string) =>
  getState().search_cache.hasOwnProperty(machine_query_string);

export const hasQueryFinished = (getState, machine_query_string) =>
  getState().search_cache[machine_query_string] != null;

export const getCachedQueryType = (getState, machine_query_string) =>
  getState().search_cache[machine_query_string].type;

export const getCachedQueryResults = (getState, machine_query_string) =>
  getState().search_cache[machine_query_string].results;

export const getCachedQueryBirthdays = (getState, machine_query_string) =>
  getState().search_cache[machine_query_string].birthdays;

export const getCachedQueryBirthdayInterval = (
  getState,
  machine_query_string
) => getState().search_cache[machine_query_string].birthday_interval;
