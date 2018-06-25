import { combineReducers } from 'redux'
import { routerReducer } from 'react-router-redux'

import units from '../reducers/units'
import expanded_units from '../reducers/expand_units'

export default combineReducers
  organization_units: units
  expanded_units:     expanded_units
  router:            routerReducer
