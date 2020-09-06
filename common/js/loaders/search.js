/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import { fetchQueryResults, setCurrentResults } from '@actions/search';

let prev_query = null;

export default store => store.subscribe(function() {
  const state = store.getState();

  const query = (state.search != null ? state.search.current_machine_query : undefined) || '';

  if (query !== prev_query) {
    prev_query = query;

    if (query === '') {
      return store.dispatch(setCurrentResults([]));
    } else {
      return store.dispatch(fetchQueryResults(query));
    }
  }
});
