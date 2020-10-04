import { setMachineQuery, setCurrentResults } from '@actions/search';

let prev_query = null;

const normalizeWhitespace = string => string.replace(/\s+/, ' ').trim();

export default store =>
  store.subscribe(() => {
    const state = store.getState();

    const query = state.search?.query;

    if (query !== prev_query) {
      prev_query = query;

      if (query) {
        const machine_query_string = normalizeWhitespace(query);
        store.dispatch(setMachineQuery(machine_query_string));

        if (machine_query_string === '') {
          return store.dispatch(setCurrentResults({}));
        }
      }
    }
  });
