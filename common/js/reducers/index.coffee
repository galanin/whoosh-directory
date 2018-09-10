import { combineReducers } from 'redux'
import { routerReducer } from 'react-router-redux'

import session from '@reducers/session';
import units from '@reducers/units'
import people from '@reducers/people'
import employments from '@reducers/employments'
import organization_unit from '@reducers/organization_unit'
import current_unit from '@reducers/current_unit'
import expanded_units from '@reducers/expand_units'
import initial_state from '@reducers/initial_state'
import layout from '@reducers/layout'


export default combineReducers
  session:            session
  organization_unit:  organization_unit
  units:              units
  current_unit_id:    current_unit
  people:             people
  employments:        employments
  expanded_units:     expanded_units
  initial_state:      initial_state
  layout:             layout
  routing:            routerReducer
