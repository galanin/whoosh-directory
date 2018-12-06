import { combineReducers } from 'redux'
import { routerReducer } from 'react-router-redux'

import session from '@reducers/session';
import units from '@reducers/units'
import unit_extras from '@reducers/unit_extras'
import people from '@reducers/people'
import employments from '@reducers/employments'
import current from '@reducers/current'
import expanded_units from '@reducers/expand_units'
import expanded_sub_units from '@reducers/expand_sub_units'
import initial_state from '@reducers/initial_state'
import layout from '@reducers/layout'
import search from '@reducers/search'
import search_cache from '@reducers/search_cache'


export default combineReducers
  session:            session
  units:              units
  unit_extras:        unit_extras
  current:            current
  people:             people
  employments:        employments
  expanded_units:     expanded_units
  expanded_sub_units: expanded_sub_units
  initial_state:      initial_state
  layout:             layout
  search:             search
  search_cache:       search_cache
  routing:            routerReducer
