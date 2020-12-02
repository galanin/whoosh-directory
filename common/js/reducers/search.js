import { isEqual } from 'lodash';

import { LOCATION_CHANGE } from 'connected-react-router';
import { getNewUrlParam } from '@lib/url-parsing';
import {
  URL_PARAM_RESULTS_SOURCE,
  URL_PARAM_QUERY
} from '@constants/url-parsing';

import { unpackResultsSource, unpackQuery } from '@lib/search';

import {
  SET_HUMAN_QUERY,
  SET_MACHINE_QUERY,
  SET_CURRENT_RESULTS,
  SET_RESULTS_TYPE,
  SET_RESULTS_SOURCE,
  DEFAULT_RESULTS_SOURCE
} from '@constants/search';

export default (state, action) => {
  if (!state) {
    state = { query: '', current_machine_query: '' };
  }
  switch (action.type) {
    case SET_HUMAN_QUERY:
      var new_state = Object.assign({}, state);
      new_state.query = action.query;
      return new_state;

    case SET_MACHINE_QUERY:
      new_state = Object.assign({}, state);
      new_state.current_machine_query = action.query;
      return new_state;

    case SET_CURRENT_RESULTS:
      new_state = Object.assign({}, state);
      new_state.results = action.results;
      return new_state;

    case SET_RESULTS_TYPE:
      new_state = Object.assign({}, state);
      new_state.results_type = action.results_type;
      return new_state;

    case SET_RESULTS_SOURCE:
      new_state = Object.assign({}, state);
      new_state.results_source = action.results_source;
      return new_state;

    case LOCATION_CHANGE:
      if (action.payload.action === 'POP') {
        const results_source_packed = getNewUrlParam(
          action.payload,
          URL_PARAM_RESULTS_SOURCE
        );
        const query = getNewUrlParam(action.payload, URL_PARAM_QUERY);

        new_state = Object.assign({}, state);

        if (results_source_packed) {
          const new_results_source = unpackResultsSource(results_source_packed);
          if (isEqual(new_results_source, state.results_source)) {
            state;
          } else {
            new_state.results_source = new_results_source;
          }
        } else {
          new_state.results_source = DEFAULT_RESULTS_SOURCE;
        }

        if (query) {
          new_state.current_machine_query = new_state.query = unpackQuery(
            query
          );
        } else {
          new_state.current_machine_query = new_state.query = '';
        }

        return new_state;
      } else {
        return state;
      }

    default:
      return state;
  }
};
