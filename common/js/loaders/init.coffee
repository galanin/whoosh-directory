import { loadToCall } from '@actions/to_call'
import { loadUnits } from '@actions/units'

initial_info_requested = null

export default (store) ->
  store.subscribe ->
    unless initial_info_requested
      initial_info_requested = true

      store.dispatch(loadUnits())

      setTimeout (-> store.dispatch(loadToCall())),
        10
