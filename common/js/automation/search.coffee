import { setMachineQuery, setCurrentResults } from '@actions/search'

prev_query = null

normalizeWhitespace = (string) ->
  string.replace(/\s+/, ' ').trim()

export default (store) ->
  store.subscribe ->
    state = store.getState()

    query = state.search?.query

    if query != prev_query
      prev_query = query

      if query?
        machine_query_string = normalizeWhitespace(query)
        store.dispatch(setMachineQuery(machine_query_string))

        if machine_query_string == ''
          store.dispatch(setCurrentResults({}))
