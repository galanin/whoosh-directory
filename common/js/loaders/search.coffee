import { fetchQueryResults, setCurrentResults } from '@actions/search'

prev_query = null

export default (store) ->
  store.subscribe ->
    state = store.getState()

    query = state.search?.current_machine_query || ''

    if query != prev_query
      prev_query = query

      if query == ''
        store.dispatch(setCurrentResults([]))
      else
        store.dispatch(fetchQueryResults(query))
