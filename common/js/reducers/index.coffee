import { combineReducers } from 'redux'
import { routerReducer } from 'react-router-redux'

import todos from './todos';
import units from '@reducers/units'
import expanded_units from '@reducers/expand_units'
import initial_state from '@reducers/initial_state'


export default combineReducers
  organization_units: units
  expanded_units:     expanded_units
  initial_state:      initial_state
  routing:            routerReducer
