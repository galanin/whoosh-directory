import { without, find } from 'lodash'


import {
  LOADED_TO_CALL
  ADDING_EMPLOYMENT_TO_CALL
  ADDING_CONTACT_TO_CALL
  CHECKING_EMPLOYMENT_TO_CALL
  CHECKING_CONTACT_TO_CALL
  CHANGED_TO_CALL
  DESTROYING_EMPLOYMENT_TO_CALL
  DESTROYING_CONTACT_TO_CALL
  DESTROYED_TO_CALL
} from '@constants/to_call'


default_state =
  data      : {}
  unchecked : []
  checked_today : []
  unchecked_employment_index : {}
  unchecked_contact_index : {}

export default (state = default_state, action) ->
  switch action.type

    when LOADED_TO_CALL
      new_data = {}
      new_unchecked_employment_index = {}
      new_unchecked_contact_index = {}

      for to_call in action.data
        new_data[to_call.id] = to_call

      for unchecked_to_call_id in action.unchecked
        unchecked_to_call = new_data[unchecked_to_call_id]
        new_unchecked_employment_index[unchecked_to_call.employment_id] = 1 if unchecked_to_call.employment_id?
        new_unchecked_contact_index[unchecked_to_call.contact_id] = 1 if unchecked_to_call.contact_id?

      data       : new_data
      unchecked  : action.unchecked
      checked_today : action.checked_today
      unchecked_employment_index : new_unchecked_employment_index
      unchecked_contact_index    : new_unchecked_contact_index

    when ADDING_EMPLOYMENT_TO_CALL
      new_unchecked_employment_index = Object.assign({}, state.unchecked_employment_index)
      new_unchecked_employment_index[action.employment_id] = 1

      to_call_id = find(state.checked_today, (to_call_id) -> state.data[to_call_id]?.employment_id == action.employment_id)
      if to_call_id?
        new_unchecked = [state.unchecked..., to_call_id]
        new_checked_today = without(state.checked_today, to_call_id)

      data      : state.data
      unchecked : new_unchecked || state.unchecked
      checked_today : new_checked_today || state.checked_today
      unchecked_employment_index : new_unchecked_employment_index
      unchecked_contact_index    : state.unchecked_contact_index

    when ADDING_CONTACT_TO_CALL
      new_unchecked_contact_index = Object.assign({}, state.unchecked_contact_index)
      new_unchecked_contact_index[action.contact_id] = 1

      to_call_id = find(state.checked_today, (to_call_id) -> state.data[to_call_id]?.contact_id == action.contact_id)
      if to_call_id?
        new_unchecked = [state.unchecked..., to_call_id]
        new_checked_today = without(state.checked_today, to_call_id)

      data      : state.data
      unchecked : new_unchecked || state.unchecked
      checked_today : new_checked_today || state.checked_today
      unchecked_employment_index : state.unchecked_employment_index
      unchecked_contact_index    : new_unchecked_contact_index

    when CHECKING_EMPLOYMENT_TO_CALL
      new_unchecked_employment_index = Object.assign({}, state.unchecked_employment_index)
      delete new_unchecked_employment_index[action.employment_id]
      to_call_id = find(state.checked_today, (to_call_id) -> state.data[to_call_id]?.employment_id == action.employment_id)

      if to_call_id?
        new_unchecked = without(state.unchecked, to_call_id)
        new_checked_today = [to_call_id, state.checked_today...]

      data      : state.data
      unchecked : new_unchecked || state.unchecked
      checked_today : new_checked_today || state.checked_today
      unchecked_employment_index : new_unchecked_employment_index
      unchecked_contact_index    : state.unchecked_contact_index

    when CHECKING_CONTACT_TO_CALL
      new_unchecked_contact_index = Object.assign({}, state.unchecked_contact_index)
      delete new_unchecked_contact_index[action.contact_id]
      to_call_id = find(state.checked_today, (to_call_id) -> state.data[to_call_id]?.contact_id == action.contact_id)

      if to_call_id?
        new_unchecked = without(state.unchecked, to_call_id)
        new_checked_today = [to_call_id, state.checked_today...]

      data      : state.data
      unchecked : new_unchecked || state.unchecked
      checked_today : new_checked_today || state.checked_today
      unchecked_employment_index : state.unchecked_employment_index
      unchecked_contact_index    : new_unchecked_contact_index

    when CHANGED_TO_CALL
      to_call = action.to_call

      new_data = Object.assign({}, state.data)
      new_unchecked_employment_index = {}
      new_unchecked_contact_index = {}

      new_data[to_call.id] = to_call

      for to_call_id in action.unchecked
        unchecked_to_call = new_data[to_call_id]
        new_unchecked_employment_index[unchecked_to_call.employment_id] = 1 if unchecked_to_call.employment_id?
        new_unchecked_contact_index[unchecked_to_call.contact_id] = 1 if unchecked_to_call.contact_id?

      data       : new_data
      unchecked  : action.unchecked
      checked_today : action.checked_today
      unchecked_employment_index : new_unchecked_employment_index
      unchecked_contact_index    : new_unchecked_contact_index

    when DESTROYING_EMPLOYMENT_TO_CALL
      to_call = find(state.data, (to_call) -> to_call.employment_id == action.employment_id)
      if to_call?.id?
        new_unchecked = without(state.unchecked, to_call.id)
        new_checked_today = without(state.checked_today, to_call.id)

      data      : state.data
      unchecked : new_unchecked || state.unchecked
      checked_today : new_checked_today || state.checked_today
      unchecked_employment_index : state.unchecked_employment_index
      unchecked_contact_index    : state.unchecked_contact_index

    when DESTROYING_CONTACT_TO_CALL
      to_call = find(state.data, (to_call) -> to_call.contact_id == action.contact_id)
      if to_call?.id?
        new_unchecked = without(state.unchecked, to_call.id)
        new_checked_today = without(state.checked_today, to_call.id)

      data      : state.data
      unchecked : new_unchecked || state.unchecked
      checked_today : new_checked_today || state.checked_today
      unchecked_employment_index : state.unchecked_employment_index
      unchecked_contact_index    : state.unchecked_contact_index

    when DESTROYED_TO_CALL
      new_unchecked_employment_index = {}
      new_unchecked_contact_index = {}

      for unchecked_to_call_id in action.unchecked
        unchecked_to_call = new_data[unchecked_to_call_id]
        new_unchecked_employment_index[unchecked_to_call.employment_id] = 1 if unchecked_to_call.employment_id?
        new_unchecked_contact_index[unchecked_to_call.contact_id] = 1 if unchecked_to_call.contact_id?

      data      : state.data
      unchecked : action.unchecked
      checked_today : action.checked_today
      unchecked_employment_index : new_unchecked_employment_index
      unchecked_contact_index    : new_unchecked_contact_index

    else
      state
