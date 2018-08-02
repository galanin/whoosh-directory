import { combineReducers } from 'redux'
import { routerReducer } from 'react-router-redux'

import todos from './todos';
import units from '@reducers/units'
import people from '@reducers/people'
import employments from '@reducers/employments'
import organization_unit from '@reducers/organization_unit'
import expanded_units from '@reducers/expand_units'
import initial_state from '@reducers/initial_state'
import layout from '@reducers/layout'


export default combineReducers
  organization_unit:  organization_unit
  organization_units: units
  people:             people
  employments:        employments
  expanded_units:     expanded_units
  initial_state:      initial_state
  layout:             layout
  routing:            routerReducer
