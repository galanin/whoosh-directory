import { combineReducers } from 'redux'
import { connectRouter } from 'connected-react-router'

import session from '@reducers/session';
import units from '@reducers/units'
import unit_titles from '@reducers/unit_titles'
import unit_extras from '@reducers/unit_extras'
import people from '@reducers/people'
import employments from '@reducers/employments'
import contacts from '@reducers/contacts'
import current from '@reducers/current'
import expanded_units from '@reducers/expand_units'
import expanded_sub_units from '@reducers/expand_sub_units'
import initial_state from '@reducers/initial_state'
import layout from '@reducers/layout'
import search from '@reducers/search'
import search_cache from '@reducers/search_cache'
import birthdays from '@reducers/birthdays'
import birthday_period from '@reducers/birthday_period'
import to_call from '@reducers/to_call'


export default (history) ->
  combineReducers
    session:            session
    units:              units
    unit_titles:        unit_titles
    unit_extras:        unit_extras
    current:            current
    people:             people
    employments:        employments
    contacts:           contacts
    expanded_units:     expanded_units
    expanded_sub_units: expanded_sub_units
    initial_state:      initial_state
    layout:             layout
    search:             search
    search_cache:       search_cache
    birthdays:          birthdays
    birthday_period:    birthday_period
    to_call:            to_call
    router:             connectRouter(history)
