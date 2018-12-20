import { SET_BIRTHDAY_PERIOD, EXTEND_BIRTHDAY_PERIOD_LEFT, EXTEND_BIRTHDAY_PERIOD_RIGHT } from '@constants/birthday_period'

import { extendPeriodLeft, extendPeriodRight, getOffsetsUnion } from '@lib/birthdays'


export default (state = {}, action) ->
  switch action.type

    when SET_BIRTHDAY_PERIOD
      if state.key_date != action.key_date
        key_date:         action.key_date
        day_offset_left:  action.day_offset_left
        day_offset_right: action.day_offset_right
        day_offset_start: action.day_offset_left
      else
        getOffsetsUnion(state, action)

    when EXTEND_BIRTHDAY_PERIOD_LEFT
      extendPeriodLeft(state, action.days)

    when EXTEND_BIRTHDAY_PERIOD_RIGHT
      extendPeriodRight(state, action.days)

    else
      state
