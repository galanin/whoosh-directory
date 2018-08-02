import {
  LOAD_UNIT_INFO,
  SHOW_UNIT_INFO,
} from '@constants/units'

export default (state = {}, action) ->
  switch action.type
    when LOAD_UNIT_INFO
      { loading: true }
    when SHOW_UNIT_INFO
      { loaded: true, unit_info: action.unit_info }
    else
      state
