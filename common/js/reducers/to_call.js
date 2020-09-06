/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import { without, find } from 'lodash';


import {
  LOADED_TO_CALL,
  ADDING_EMPLOYMENT_TO_CALL,
  ADDING_CONTACT_TO_CALL,
  CHECKING_EMPLOYMENT_TO_CALL,
  CHECKING_CONTACT_TO_CALL,
  CHANGED_TO_CALL,
  DESTROYING_EMPLOYMENT_TO_CALL,
  DESTROYING_CONTACT_TO_CALL,
  DESTROYED_TO_CALL
} from '@constants/to_call';


const default_state = {
  data      : {},
  unchecked : [],
  checked_today : [],
  unchecked_employment_index : {},
  unchecked_contact_index : {}
};

export default (function(state, action) {
  let new_checked_today, new_unchecked, to_call, unchecked_to_call, unchecked_to_call_id;
  if (state == null) { state = default_state; }
  switch (action.type) {

    case LOADED_TO_CALL:
      var new_data = {};
      var new_unchecked_employment_index = {};
      var new_unchecked_contact_index = {};

      for (to_call of Array.from(action.data)) {
        new_data[to_call.id] = to_call;
      }

      for (unchecked_to_call_id of Array.from(action.unchecked)) {
        unchecked_to_call = new_data[unchecked_to_call_id];
        if (unchecked_to_call.employment_id != null) { new_unchecked_employment_index[unchecked_to_call.employment_id] = 1; }
        if (unchecked_to_call.contact_id != null) { new_unchecked_contact_index[unchecked_to_call.contact_id] = 1; }
      }

      return {
        data       : new_data,
        unchecked  : action.unchecked,
        checked_today : action.checked_today,
        unchecked_employment_index : new_unchecked_employment_index,
        unchecked_contact_index    : new_unchecked_contact_index
      };

    case ADDING_EMPLOYMENT_TO_CALL:
      new_unchecked_employment_index = Object.assign({}, state.unchecked_employment_index);
      new_unchecked_employment_index[action.employment_id] = 1;

      var to_call_id = find(state.checked_today, to_call_id => (state.data[to_call_id] != null ? state.data[to_call_id].employment_id : undefined) === action.employment_id);
      if (to_call_id != null) {
        new_unchecked = [...Array.from(state.unchecked), to_call_id];
        new_checked_today = without(state.checked_today, to_call_id);
      }

      return {
        data      : state.data,
        unchecked : new_unchecked || state.unchecked,
        checked_today : new_checked_today || state.checked_today,
        unchecked_employment_index : new_unchecked_employment_index,
        unchecked_contact_index    : state.unchecked_contact_index
      };

    case ADDING_CONTACT_TO_CALL:
      new_unchecked_contact_index = Object.assign({}, state.unchecked_contact_index);
      new_unchecked_contact_index[action.contact_id] = 1;

      to_call_id = find(state.checked_today, to_call_id => (state.data[to_call_id] != null ? state.data[to_call_id].contact_id : undefined) === action.contact_id);
      if (to_call_id != null) {
        new_unchecked = [...Array.from(state.unchecked), to_call_id];
        new_checked_today = without(state.checked_today, to_call_id);
      }

      return {
        data      : state.data,
        unchecked : new_unchecked || state.unchecked,
        checked_today : new_checked_today || state.checked_today,
        unchecked_employment_index : state.unchecked_employment_index,
        unchecked_contact_index    : new_unchecked_contact_index
      };

    case CHECKING_EMPLOYMENT_TO_CALL:
      new_unchecked_employment_index = Object.assign({}, state.unchecked_employment_index);
      delete new_unchecked_employment_index[action.employment_id];
      to_call_id = find(state.checked_today, to_call_id => (state.data[to_call_id] != null ? state.data[to_call_id].employment_id : undefined) === action.employment_id);

      if (to_call_id != null) {
        new_unchecked = without(state.unchecked, to_call_id);
        new_checked_today = [to_call_id, ...Array.from(state.checked_today)];
      }

      return {
        data      : state.data,
        unchecked : new_unchecked || state.unchecked,
        checked_today : new_checked_today || state.checked_today,
        unchecked_employment_index : new_unchecked_employment_index,
        unchecked_contact_index    : state.unchecked_contact_index
      };

    case CHECKING_CONTACT_TO_CALL:
      new_unchecked_contact_index = Object.assign({}, state.unchecked_contact_index);
      delete new_unchecked_contact_index[action.contact_id];
      to_call_id = find(state.checked_today, to_call_id => (state.data[to_call_id] != null ? state.data[to_call_id].contact_id : undefined) === action.contact_id);

      if (to_call_id != null) {
        new_unchecked = without(state.unchecked, to_call_id);
        new_checked_today = [to_call_id, ...Array.from(state.checked_today)];
      }

      return {
        data      : state.data,
        unchecked : new_unchecked || state.unchecked,
        checked_today : new_checked_today || state.checked_today,
        unchecked_employment_index : state.unchecked_employment_index,
        unchecked_contact_index    : new_unchecked_contact_index
      };

    case CHANGED_TO_CALL:
      ({
        to_call
      } = action);

      new_data = Object.assign({}, state.data);
      new_unchecked_employment_index = {};
      new_unchecked_contact_index = {};

      new_data[to_call.id] = to_call;

      for (to_call_id of Array.from(action.unchecked)) {
        unchecked_to_call = new_data[to_call_id];
        if (unchecked_to_call.employment_id != null) { new_unchecked_employment_index[unchecked_to_call.employment_id] = 1; }
        if (unchecked_to_call.contact_id != null) { new_unchecked_contact_index[unchecked_to_call.contact_id] = 1; }
      }

      return {
        data       : new_data,
        unchecked  : action.unchecked,
        checked_today : action.checked_today,
        unchecked_employment_index : new_unchecked_employment_index,
        unchecked_contact_index    : new_unchecked_contact_index
      };

    case DESTROYING_EMPLOYMENT_TO_CALL:
      to_call = find(state.data, to_call => to_call.employment_id === action.employment_id);
      if ((to_call != null ? to_call.id : undefined) != null) {
        new_unchecked = without(state.unchecked, to_call.id);
        new_checked_today = without(state.checked_today, to_call.id);
      }

      return {
        data      : state.data,
        unchecked : new_unchecked || state.unchecked,
        checked_today : new_checked_today || state.checked_today,
        unchecked_employment_index : state.unchecked_employment_index,
        unchecked_contact_index    : state.unchecked_contact_index
      };

    case DESTROYING_CONTACT_TO_CALL:
      to_call = find(state.data, to_call => to_call.contact_id === action.contact_id);
      if ((to_call != null ? to_call.id : undefined) != null) {
        new_unchecked = without(state.unchecked, to_call.id);
        new_checked_today = without(state.checked_today, to_call.id);
      }

      return {
        data      : state.data,
        unchecked : new_unchecked || state.unchecked,
        checked_today : new_checked_today || state.checked_today,
        unchecked_employment_index : state.unchecked_employment_index,
        unchecked_contact_index    : state.unchecked_contact_index
      };

    case DESTROYED_TO_CALL:
      new_unchecked_employment_index = {};
      new_unchecked_contact_index = {};

      for (unchecked_to_call_id of Array.from(action.unchecked)) {
        unchecked_to_call = state.data[unchecked_to_call_id];
        if (unchecked_to_call.employment_id != null) { new_unchecked_employment_index[unchecked_to_call.employment_id] = 1; }
        if (unchecked_to_call.contact_id != null) { new_unchecked_contact_index[unchecked_to_call.contact_id] = 1; }
      }

      return {
        data      : state.data,
        unchecked : action.unchecked,
        checked_today : action.checked_today,
        unchecked_employment_index : new_unchecked_employment_index,
        unchecked_contact_index    : new_unchecked_contact_index
      };

    default:
      return state;
  }
});
