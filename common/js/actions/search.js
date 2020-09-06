/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
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

export var setQuery = query_string => ({
  type: SET_HUMAN_QUERY,
  query: query_string
});

export var setMachineQuery = query_string => ({
  type: SET_MACHINE_QUERY,
  query: query_string
});

// RESULTS_SOURCE_* -> 'birthday' or 'query'
export var setResultsSource = results_source => ({
  type: SET_RESULTS_SOURCE,
  results_source
});

// 'birthday' or 'common'
export var setResultsType = results_type => ({
  type: SET_RESULTS_TYPE,
  results_type
});

const isCurrentMachineQuery = (getState, query) =>
  query === getState().search.current_machine_query;

export var forceQueryResults = () => (dispatch, getState) =>
  dispatch(fetchQueryResults(getState().search.current_machine_query));

export var fetchQueryResults = machine_query_string =>
  function(dispatch, getState) {
    if (hasQuerySent(getState, machine_query_string)) {
      if (hasQueryFinished(getState, machine_query_string)) {
        // fetch from the cache
        dispatch(
          setResultsType(getCachedQueryType(getState, machine_query_string))
        );

        const results = getCachedQueryResults(getState, machine_query_string);
        if (results != null) {
          dispatch(setCurrentResults(results));
        }

        const birthdays = getCachedQueryBirthdays(
          getState,
          machine_query_string
        );
        if (birthdays != null) {
          dispatch(setBirthdayResults(birthdays));
        }

        const birthday_interval = getCachedQueryBirthdayInterval(
          getState,
          machine_query_string
        );
        if (birthday_interval != null) {
          return dispatch(setBirthdayPeriodByInterval(...birthday_interval));
        }
      } else {
      }
      // do nothing, wait until a query has finished
    } else {
      // send a real query
      return dispatch(sendQuery(machine_query_string));
    }
  };

export var sendQuery = machine_query_string =>
  function(dispatch, getState) {
    dispatch(setSearchRunning(machine_query_string));
    return Request.get('/search')
      .query({ q: machine_query_string })
      .then(
        function(response) {
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

          if (response.body.people != null) {
            dispatch(addPeople(response.body.people));
          }
          if (response.body.employments != null) {
            dispatch(addEmployments(response.body.employments));
          }
          if (response.body.external_contacts != null) {
            dispatch(addContacts(response.body.external_contacts));
          }
          if (response.body.units != null) {
            dispatch(addUnits(response.body.units));
          }

          if (isCurrentMachineQuery(getState, response.body.query)) {
            if (response.body.results != null) {
              dispatch(setCurrentResults(response.body.results));
            }
            if (response.body.birthday_interval != null) {
              dispatch(
                setBirthdayPeriodByInterval(...response.body.birthday_interval)
              );
            }
          }

          if (response.body.birthdays != null) {
            return dispatch(setBirthdayResults(response.body.birthdays));
          }
        },

        function(error) {}
      );
  };

export var setCurrentResults = results => ({
  type: SET_CURRENT_RESULTS,
  results
});
