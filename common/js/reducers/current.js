/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import { LOCATION_CHANGE } from 'connected-react-router';
import { setCurrentUnit } from '@actions/current';
import { getNewUrlParam } from '@lib/url-parsing';

import {
  SET_CURRENT_UNIT_ID,
  SET_HIGHLIGHTED_UNIT_ID,
  SET_CURRENT_EMPLOYMENT_ID,
  SET_CURRENT_CONTACT_ID,
  SCROLL_TO_UNIT,
  SCROLLED_TO_UNIT
} from '@constants/current';

import {
  URL_PARAM_UNIT,
  URL_PARAM_EMPLOYMENT,
  URL_PARAM_CONTACT,
  URL_PARAM_LAYOUT,
  URL_PARAM_RESULTS_SOURCE,
  URL_PARAM_BIRTHDAY_PERIOD
} from '@constants/url-parsing';


export default (function(state, action) {
  if (state == null) { state = {}; }
  switch (action.type) {

    case SET_CURRENT_UNIT_ID:
      var new_state = Object.assign({}, state);
      new_state.unit_id = action.unit_id;
      return new_state;

    case SET_HIGHLIGHTED_UNIT_ID:
      new_state = Object.assign({}, state);
      new_state.highlighted_unit_id = action.unit_id;
      return new_state;

    case SET_CURRENT_EMPLOYMENT_ID:
      new_state = Object.assign({}, state);
      new_state.employment_id = action.employment_id;
      delete new_state.contact_id;
      return new_state;

    case SET_CURRENT_CONTACT_ID:
      new_state = Object.assign({}, state);
      new_state.contact_id = action.contact_id;
      delete new_state.employment_id;
      return new_state;

    case SCROLL_TO_UNIT:
      new_state = Object.assign({}, state);
      new_state.scroll_to_unit_id = action.unit_id;
      return new_state;

    case SCROLLED_TO_UNIT:
      new_state = Object.assign({}, state);
      if (new_state.scroll_to_unit_id === action.unit_id) {
        delete new_state.scroll_to_unit_id;
      }
      return new_state;

    case LOCATION_CHANGE:
      if (action.payload.action === 'POP') {
        const employment_id = getNewUrlParam(action.payload, URL_PARAM_EMPLOYMENT);
        const contact_id = getNewUrlParam(action.payload, URL_PARAM_CONTACT);
        new_state = Object.assign({}, state);

        if (employment_id != null) {
          new_state.employment_id = employment_id;
        } else {
          delete new_state.employment_id;
        }

        if (contact_id != null) {
          new_state.contact_id = contact_id;
        } else {
          delete new_state.contact_id;
        }

        return new_state;

      } else {
        return state;
      }

    default:
      return state;
  }
});
