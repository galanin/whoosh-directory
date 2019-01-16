import { loadUnitExtra } from '@actions/unit_extras'


requested_unit_ids = {}

loadExtra = (store, unit_id) ->
  unless requested_unit_ids[unit_id]?
    requested_unit_ids[unit_id] = true
    store.dispatch(loadUnitExtra(unit_id))

export default (store) ->
  store.subscribe ->
    state = store.getState()

    unit_id = state.current?.unit_id

    if unit_id?
      loadExtra(store, unit_id)

    for unit_id, _ of state.expanded_sub_units
      loadExtra(store, unit_id)
