import { resetExpandedSubUnits } from '@actions/expand_sub_units'


prev_unit_id = null

export default (store) ->
  store.subscribe ->
    state = store.getState()

    unit_id = state.current?.unit_id

    if unit_id != prev_unit_id
      prev_unit_id = unit_id

      if unit_id?
        store.dispatch(resetExpandedSubUnits())
