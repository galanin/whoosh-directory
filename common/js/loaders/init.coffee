import { loadToCall } from '@actions/to_call'

initial_info_requested = null

export default (store) ->
  store.subscribe ->
    unless initial_info_requested
      initial_info_requested = true

      store.dispatch(loadToCall())
