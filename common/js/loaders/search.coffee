import { fetchQueryResults } from '@actions/search'

prev_query = null

export default (store) ->
  store.subscribe ->
    state = store.getState()

    query = state.search?.current_machine_query

    if query? and query != prev_query
      prev_query = query
      store.dispatch(fetchQueryResults(query))
