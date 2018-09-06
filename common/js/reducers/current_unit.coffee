import { SET_CURRENT_UNIT_ID } from '@constants/current_unit'

export default (state = null, action) ->
  switch action.type
    when SET_CURRENT_UNIT_ID
      action.unit_id

    else
      state
