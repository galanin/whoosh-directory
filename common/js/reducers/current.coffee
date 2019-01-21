import { LOCATION_CHANGE } from 'connected-react-router'
import { setCurrentUnit } from '@actions/current'
import { getNewUrlParam } from '@lib/url-parsing'

import {
  SET_CURRENT_UNIT_ID
  SET_HIGHLIGHTED_UNIT_ID
  SET_CURRENT_EMPLOYMENT_ID
  SET_CURRENT_CONTACT_ID
  SCROLL_TO_UNIT
  SCROLLED_TO_UNIT
} from '@constants/current'

import {
  URL_PARAM_UNIT
  URL_PARAM_EMPLOYMENT
  URL_PARAM_CONTACT
  URL_PARAM_LAYOUT
  URL_PARAM_RESULTS_SOURCE
  URL_PARAM_BIRTHDAY_PERIOD
} from '@constants/url-parsing'


export default (state = {}, action) ->
  switch action.type

    when SET_CURRENT_UNIT_ID
      new_state = Object.assign({}, state)
      new_state.unit_id = action.unit_id
      new_state

    when SET_HIGHLIGHTED_UNIT_ID
      new_state = Object.assign({}, state)
      new_state.highlighted_unit_id = action.unit_id
      new_state

    when SET_CURRENT_EMPLOYMENT_ID
      new_state = Object.assign({}, state)
      new_state.employment_id = action.employment_id
      delete new_state.contact_id
      new_state

    when SET_CURRENT_CONTACT_ID
      new_state = Object.assign({}, state)
      new_state.contact_id = action.contact_id
      delete new_state.employment_id
      new_state

    when SCROLL_TO_UNIT
      new_state = Object.assign({}, state)
      new_state.scroll_to_unit_id = action.unit_id
      new_state

    when SCROLLED_TO_UNIT
      new_state = Object.assign({}, state)
      if new_state.scroll_to_unit_id == action.unit_id
        delete new_state.scroll_to_unit_id
      new_state

    when LOCATION_CHANGE
      if action.payload.action == 'POP'
        unit_id = getNewUrlParam(action.payload, URL_PARAM_UNIT)
        employment_id = getNewUrlParam(action.payload, URL_PARAM_EMPLOYMENT)
        contact_id = getNewUrlParam(action.payload, URL_PARAM_CONTACT)
        new_state = Object.assign({}, state)

        if unit_id?
          new_state.unit_id = unit_id
        else
          delete new_state.unit_id

        if employment_id?
          new_state.employment_id = employment_id
        else
          delete new_state.employment_id

        if contact_id?
          new_state.contact_id = contact_id
        else
          delete new_state.contact_id

        new_state

      else
        state

    else
      state
