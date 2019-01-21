import { loadEmployments, loadEmploymentHierarchy, loadUnitHierarchy } from '@actions/employments'

requested_employment_ids = {}
requested_hierarchy_employment_ids = {}

export default (store) ->
  store.subscribe ->
    state = store.getState()

    employment_id = state.current?.employment_id

    if employment_id?
      if state.employments[employment_id]?
        unless requested_employment_ids[employment_id]?
          requested_employment_ids[employment_id] = true
          store.dispatch(loadEmploymentHierarchy(employment_id))
          store.dispatch(loadUnitHierarchy(employment_id))
      else
        unless requested_hierarchy_employment_ids[employment_id]?
          requested_hierarchy_employment_ids[employment_id] = true
          store.dispatch(loadEmployments([employment_id]))
