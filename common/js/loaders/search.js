import { fetchQueryResults, setCurrentResults } from '@actions/search';

let prev_query = null;

export default store =>
  store.subscribe(() => {
    const state = store.getState();

    const query = state.search?.current_machine_query || '';

    if (query !== prev_query) {
      prev_query = query;

      if (query === '') {
        return store.dispatch(setCurrentResults([]));
      } else {
        return store.dispatch(fetchQueryResults(query));
      }
    }
  });
