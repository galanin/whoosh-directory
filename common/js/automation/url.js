let prev_birthday_period,
  prev_contact_id,
  prev_employment_id,
  prev_pushed_at,
  prev_results_source;
import { push, replace } from 'connected-react-router';
import { isEqual } from 'lodash';
import { isDefaultLayout, packLayout } from '@lib/layout';
import {
  isDefaultResultsSource,
  packResultsSource,
  packQuery
} from '@lib/search';
import {
  isEqualBirthdayPeriod,
  isPresentBirthdayPeriod,
  prevBirthdayPeriod,
  packBirthdayPeriod
} from '@lib/birthdays';

import {
  URL_PARAM_NODE,
  URL_PARAM_EMPLOYMENT,
  URL_PARAM_CONTACT,
  URL_PARAM_LAYOUT,
  URL_PARAM_RESULTS_SOURCE,
  URL_PARAM_BIRTHDAY_PERIOD,
  URL_PARAM_QUERY
} from '@constants/url-parsing';

let prev_node_id = (prev_employment_id = prev_contact_id = prev_birthday_period = prev_results_source = prev_pushed_at = undefined);
let prev_query = '';
let prev_layout = [];

export default store =>
  store.subscribe(() => {
    const state = store.getState();

    const changed_params = [];

    const node_id = state.nodes.current_id;
    if (node_id !== prev_node_id) {
      changed_params.push('node_id');
    }

    const employment_id =
      state.current != null ? state.current.employment_id : undefined;
    if (employment_id !== prev_employment_id) {
      changed_params.push('employment_id');
    }

    const contact_id =
      state.current != null ? state.current.contact_id : undefined;
    if (contact_id !== prev_contact_id) {
      changed_params.push('contact_id');
    }

    const { birthday_period } = state;
    if (!isEqualBirthdayPeriod(birthday_period, prev_birthday_period)) {
      changed_params.push('birthday_period');
    }

    const layout = state.layout != null ? state.layout.pile : undefined;
    if (!isEqual(layout, prev_layout)) {
      changed_params.push('layout');
    }

    const results_source =
      state.search != null ? state.search.results_source : undefined;
    if (results_source !== prev_results_source) {
      changed_params.push('results_source');
    }

    const query =
      state.search != null ? state.search.current_machine_query : undefined;
    if (query !== prev_query) {
      changed_params.push('query');
    }

    if (changed_params.length > 0) {
      const path_components = [];

      prev_node_id = node_id;
      if (node_id != null) {
        path_components.push(`${URL_PARAM_NODE}-${node_id}`);
      }

      prev_employment_id = employment_id;
      if (employment_id != null) {
        path_components.push(`${URL_PARAM_EMPLOYMENT}-${employment_id}`);
      }

      prev_contact_id = contact_id;
      if (contact_id != null) {
        path_components.push(`${URL_PARAM_CONTACT}-${contact_id}`);
      }

      prev_birthday_period = prevBirthdayPeriod(birthday_period);
      if (isPresentBirthdayPeriod(birthday_period)) {
        path_components.push(
          `${URL_PARAM_BIRTHDAY_PERIOD}-${packBirthdayPeriod(birthday_period)}`
        );
      }

      prev_layout = layout;
      if (!isDefaultLayout(layout)) {
        path_components.push(`${URL_PARAM_LAYOUT}-${packLayout(layout)}`);
      }

      prev_results_source = results_source;
      if (!isDefaultResultsSource(results_source)) {
        path_components.push(
          `${URL_PARAM_RESULTS_SOURCE}-${packResultsSource(results_source)}`
        );
      }

      const query_edited =
        changed_params.indexOf('query') >= 0 && prev_query.length > 0;
      prev_query = query;
      if (query.length > 0) {
        path_components.push(`${URL_PARAM_QUERY}-${packQuery(query)}`);
      }

      const new_path = decodeURI('/' + path_components.join('/'));

      if (new_path !== state.router.location.pathname) {
        const now = new Date();
        const recently_changed =
          prev_pushed_at != null && now - prev_pushed_at < 500;
        const go_through = !query_edited && recently_changed;
        const action = go_through || query_edited ? replace : push;
        store.dispatch(action(new_path));
        return (prev_pushed_at = now);
      }
    }
  });
