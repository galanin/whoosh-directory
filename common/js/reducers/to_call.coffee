import { clone } from 'lodash'


import {
  LOADED_TO_CALL
  ADDING_TO_CALL
  CHECKING_TO_CALL
  CHANGED_TO_CALL
  DESTROYING_TO_CALL
  DESTROYED_TO_CALL
} from '@constants/to_call'


export default (state = null, action) ->
  switch action.type

    when LOADED_TO_CALL
      new_data = {}
      new_unchecked_employment_index = {}

      for to_call in action.data
        new_data[to_call.id] = to_call

      for to_call_id in action.unchecked
        new_unchecked_employment_index[new_data[to_call_id].employment_id] = 1

      data       : new_data
      unchecked  : action.unchecked
      checked    : action.checked
      unchecked_employment_index : new_unchecked_employment_index

    when ADDING_TO_CALL
      new_unchecked_employment_index = if state?.unchecked_employment_index? then Object.assign({}, state.unchecked_employment_index) else {}
      new_unchecked_employment_index[action.employment_id] = 1

      data      : state?.data || {}
      unchecked : state?.unchecked || []
      checked   : state?.checked || []
      unchecked_employment_index : new_unchecked_employment_index

    when CHECKING_TO_CALL
      new_unchecked_employment_index = if state?.unchecked_employment_index? then Object.assign({}, state.unchecked_employment_index) else {}
      delete new_unchecked_employment_index[action.employment_id]

      data      : state?.data || {}
      unchecked : state?.unchecked || []
      checked   : state?.checked || []
      unchecked_employment_index : new_unchecked_employment_index

    when CHANGED_TO_CALL
      new_data = Object.assign({}, state.data)
      new_data[action.to_call.id] = action.to_call
      new_unchecked_employment_index = {}

      for to_call_id in action.unchecked
        new_unchecked_employment_index[new_data[to_call_id].employment_id] = 1

      data       : new_data
      unchecked  : action.unchecked
      checked    : action.checked
      unchecked_employment_index : new_unchecked_employment_index

    when DESTROYING_TO_CALL
      new_state = Object.assign({}, state)
      new_state

    else
      state
