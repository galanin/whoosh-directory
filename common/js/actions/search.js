import { Request } from '@lib/request';

import {
  SEND_QUERY,
  SET_CURRENT_RESULTS,
  SET_HUMAN_QUERY,
  SET_MACHINE_QUERY,
  SET_RESULTS_TYPE,
  SET_RESULTS_SOURCE
} from '@constants/search';

import { addUnits } from '@actions/units';
import { addPeople } from '@actions/people';
import { addEmployments } from '@actions/employments';
import { addContacts } from '@actions/contacts';
import { popSearchResults } from '@actions/layout';
import {
  setSearchRunning,
  setSearchFinished,
  hasQuerySent,
  hasQueryFinished,
  getCachedQueryType,
  getCachedQueryResults,
  getCachedQueryBirthdays,
  getCachedQueryBirthdayInterval
} from '@actions/search_cache';
import { setBirthdayPeriodByInterval } from '@actions/birthday_period';
import { setBirthdayResults } from '@actions/birthdays';

export const setQuery = query_string => ({
  type: SET_HUMAN_QUERY,
  query: query_string
});

export const setMachineQuery = query_string => ({
  type: SET_MACHINE_QUERY,
  query: query_string
});

// RESULTS_SOURCE_* -> 'birthday' or 'query'
export const setResultsSource = results_source => ({
  type: SET_RESULTS_SOURCE,
  results_source
});

// 'birthday' or 'common'
export const setResultsType = results_type => ({
  type: SET_RESULTS_TYPE,
  results_type
});

const isCurrentMachineQuery = (getState, query) =>
  query === getState().search.current_machine_query;

export const forceQueryResults = () => (dispatch, getState) =>
  dispatch(fetchQueryResults(getState().search.current_machine_query));

export const fetchQueryResults = machine_query_string => (
  dispatch,
  getState
) => {
  if (hasQuerySent(getState, machine_query_string)) {
    if (hasQueryFinished(getState, machine_query_string)) {
      // fetch from the cache
      dispatch(
        setResultsType(getCachedQueryType(getState, machine_query_string))
      );

      const results = getCachedQueryResults(getState, machine_query_string);
      if (results) {
        dispatch(setCurrentResults(results));
      }

      const birthdays = getCachedQueryBirthdays(getState, machine_query_string);
      if (birthdays) {
        dispatch(setBirthdayResults(birthdays));
      }

      const birthday_interval = getCachedQueryBirthdayInterval(
        getState,
        machine_query_string
      );
      if (birthday_interval) {
        return dispatch(setBirthdayPeriodByInterval(...birthday_interval));
      }
    }
    // do nothing, wait until a query has finished
  } else {
    // send a real query
    return dispatch(sendQuery(machine_query_string));
  }
};

export const sendQuery = machine_query_string => (dispatch, getState) => {
  dispatch(setSearchRunning(machine_query_string));
  return Request.get('/search')
    .query({ q: machine_query_string })
    .then(
      response => {
        dispatch(
          setSearchFinished(
            machine_query_string,
            response.body.type,
            response.body.results,
            response.body.birthday_interval,
            response.body.birthdays
          )
        );

        dispatch(setResultsType(response.body.type));

        if (response.body.people) {
          dispatch(addPeople(response.body.people));
        }
        if (response.body.employments) {
          dispatch(addEmployments(response.body.employments));
        }
        if (response.body.external_contacts) {
          dispatch(addContacts(response.body.external_contacts));
        }
        if (response.body.units) {
          dispatch(addUnits(response.body.units));
        }

        if (isCurrentMachineQuery(getState, response.body.query)) {
          if (response.body.results) {
            dispatch(setCurrentResults(response.body.results));
          }
          if (response.body.birthday_interval) {
            dispatch(
              setBirthdayPeriodByInterval(...response.body.birthday_interval)
            );
          }
        }

        if (response.body.birthdays) {
          return dispatch(setBirthdayResults(response.body.birthdays));
        }
      },

      error => {}
    );
};

export const setCurrentResults = results => ({
  type: SET_CURRENT_RESULTS,
  results
});
