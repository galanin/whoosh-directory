import { without } from 'lodash'


import {
  LOADED_TO_CALL
  ADDING_TO_CALL
  CHECKING_TO_CALL
  CHANGED_TO_CALL
  DESTROYING_TO_CALL
  DESTROYED_TO_CALL
} from '@constants/to_call'


default_state =
  data      : {}
  unchecked : []
  checked   : []
  employment_index : {}
  unchecked_employment_index : {}

export default (state = default_state, action) ->
  switch action.type

    when LOADED_TO_CALL
      new_data = {}
      new_unchecked_employment_index = {}
      new_employment_index = {}

      for to_call in action.data
        new_data[to_call.id] = to_call
        new_employment_index[to_call.employment_id] = to_call

      for to_call_id in action.unchecked
        new_unchecked_employment_index[new_data[to_call_id].employment_id] = 1

      data       : new_data
      unchecked  : action.unchecked
      checked_today    : action.checked_today
      employment_index : new_employment_index
      unchecked_employment_index : new_unchecked_employment_index

    when ADDING_TO_CALL
      new_unchecked_employment_index = Object.assign({}, state.unchecked_employment_index)
      new_unchecked_employment_index[action.employment_id] = 1

      to_call = state.employment_index[action.employment_id]
      if to_call?.id?
        new_unchecked = [state.unchecked..., to_call.id]
        new_checked_today = without(state.checked_today, to_call.id)

      data      : state.data
      unchecked : new_unchecked || state.unchecked
      checked_today    : new_checked_today || state.checked_today
      employment_index : state.employment_index
      unchecked_employment_index : new_unchecked_employment_index

    when CHECKING_TO_CALL
      new_unchecked_employment_index = if state?.unchecked_employment_index? then Object.assign({}, state.unchecked_employment_index) else {}
      delete new_unchecked_employment_index[action.employment_id]

      to_call = state.employment_index[action.employment_id]
      if to_call?.id?
        new_unchecked = without(state.unchecked, to_call.id)
        new_checked_today = [to_call.id, state.checked_today...]

      data      : state.data
      unchecked : new_unchecked || state.unchecked
      checked_today    : new_checked_today || state.checked_today
      employment_index : state.employment_index
      unchecked_employment_index : new_unchecked_employment_index

    when CHANGED_TO_CALL
      new_data = Object.assign({}, state.data)
      new_employment_index = Object.assign({}, state.employment_index)
      new_unchecked_employment_index = {}

      new_data[action.to_call.id] = action.to_call
      new_employment_index[action.to_call.employment_id] = action.to_call

      for to_call_id in action.unchecked
        new_unchecked_employment_index[new_data[to_call_id].employment_id] = 1

      data       : new_data
      unchecked  : action.unchecked
      checked_today    : action.checked_today
      employment_index : new_employment_index
      unchecked_employment_index : new_unchecked_employment_index

    when DESTROYING_TO_CALL
      to_call = state.employment_index[action.employment_id]
      if to_call?.id?
        new_unchecked = without(state.unchecked, to_call.id)
        new_checked_today = without(state.checked_today, to_call.id)

      data      : state.data
      unchecked : new_unchecked || state.unchecked
      checked_today    : new_checked_today || state.checked_today
      employment_index : state.employment_index
      unchecked_employment_index : state.unchecked_employment_index

    when DESTROYED_TO_CALL
      data      : state.data
      unchecked : action.unchecked
      checked_today    : action.checked_today
      employment_index : state.employment_index
      unchecked_employment_index : state.unchecked_employment_index

    else
      state
