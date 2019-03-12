import { isEmpty } from 'lodash'

import { getNodeParentIds, loadEmployments } from '@actions/employments'
import { loadMissingNodeData } from '@actions/nodes'

requested_employment_ids = {}
requested_hierarchy_employment_ids = {}

export default (store) ->
  store.subscribe ->
    state = store.getState()

    employment_id = state.current?.employment_id
    employment = state.employments[employment_id]

    if employment_id?
      if employment?
        unless isEmpty(state.nodes.tree)
          unless requested_hierarchy_employment_ids[employment_id]?
            requested_hierarchy_employment_ids[employment_id] = true

            parent_ids = getNodeParentIds(state, employment)
            store.dispatch(loadMissingNodeData(parent_ids))
      else
        unless requested_employment_ids[employment_id]?
          requested_employment_ids[employment_id] = true
          store.dispatch(loadEmployments([employment_id]))
