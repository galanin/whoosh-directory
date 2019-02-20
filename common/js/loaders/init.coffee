import { loadUnits } from '@actions/units'
import { loadExpandedUnits } from '@actions/expand_units'
import { loadToCall } from '@actions/to_call'
import { loadFavoritePeople, loadFavoriteUnits } from '@actions/favorites'

initial_info_requested = null

export default (store) ->
  store.subscribe ->
    unless initial_info_requested
      initial_info_requested = true

      store.dispatch(loadUnits())

      setTimeout (-> store.dispatch(loadExpandedUnits())),
        10

      setTimeout (-> store.dispatch(loadToCall())),
        30
      setTimeout (-> store.dispatch(loadFavoritePeople())),
        31
      setTimeout (-> store.dispatch(loadFavoriteUnits())),
        42
