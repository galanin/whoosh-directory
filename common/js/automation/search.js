/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import { setMachineQuery, setCurrentResults } from '@actions/search';

let prev_query = null;

const normalizeWhitespace = string => string.replace(/\s+/, ' ').trim();

export default store => store.subscribe(function() {
  const state = store.getState();

  const query = state.search != null ? state.search.query : undefined;

  if (query !== prev_query) {
    prev_query = query;

    if (query != null) {
      const machine_query_string = normalizeWhitespace(query);
      store.dispatch(setMachineQuery(machine_query_string));

      if (machine_query_string === '') {
        return store.dispatch(setCurrentResults({}));
      }
    }
  }
});
