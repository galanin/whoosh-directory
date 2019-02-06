import { loadUnits } from '@actions/units'
import { loadExpandedUnits } from '@actions/expand_units'
import { loadToCall } from '@actions/to_call'

initial_info_requested = null

export default (store) ->
  store.subscribe ->
    unless initial_info_requested
      initial_info_requested = true

      store.dispatch(loadUnits())

      setTimeout (-> store.dispatch(loadExpandedUnits())),
        10

      setTimeout (-> store.dispatch(loadToCall())),
        100
