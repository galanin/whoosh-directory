import { LOCATION_CHANGE } from 'connected-react-router'
import { getNewUrlParam } from '@lib/url-parsing'
import { URL_PARAM_BIRTHDAY_PERIOD } from '@constants/url-parsing'

import {
  SET_BIRTHDAY_PERIOD
  SET_BIRTHDAY_PERIOD_BY_DATE
  EXTEND_BIRTHDAY_PERIOD_LEFT
  EXTEND_BIRTHDAY_PERIOD_RIGHT
  SCROLLED_TO_DATE
} from '@constants/birthday_period'

import { dayNumberByDate } from '@lib/datetime'
import { limitExtension, getOffsetsUnion, getOffsetsByShortcut, unpackBirthdayPeriod } from '@lib/birthdays'


export default (state = {}, action) ->
  switch action.type

    when SET_BIRTHDAY_PERIOD
      if state.key_date != action.key_date
        key_date:         action.key_date
        day_offset_left:  action.day_offset_left
        day_offset_right: action.day_offset_right
        day_offset_start: action.day_offset_left
        day_scroll_to:    action.day_offset_left
      else
        getOffsetsUnion(state, action)

    when SET_BIRTHDAY_PERIOD_BY_DATE
      day1 = dayNumberByDate(action.date1)
      day2 = dayNumberByDate(action.date2)
      if day2 < day1
        day2 += 366
      key_date:         day1
      day_offset_left:  0
      day_offset_right: day2 - day1
      day_offset_start: 0
      day_scroll_to:    0

    when EXTEND_BIRTHDAY_PERIOD_LEFT
      max_extension = limitExtension(state, action.days)
      left = state.day_offset_left - max_extension
    
      key_date:         state.key_date
      day_offset_left:  left
      day_offset_right: state.day_offset_right
      day_offset_start: left
      day_scroll_to:    left
      prev_day_offset_left: state.day_offset_left

    when EXTEND_BIRTHDAY_PERIOD_RIGHT
      max_extension = limitExtension(state, action.days)
      right = state.day_offset_right + max_extension
      start = Math.min(right, state.day_offset_right + 1)

      key_date:         state.key_date
      day_offset_left:  state.day_offset_left
      day_offset_right: right
      day_offset_start: start
      day_scroll_to:    start

    when SCROLLED_TO_DATE
      new_state = Object.assign({}, state)
      delete new_state.day_scroll_to
      new_state

    when LOCATION_CHANGE
      if action.payload.action == 'POP'
        birthday_period_packed = getNewUrlParam(action.payload, URL_PARAM_BIRTHDAY_PERIOD)
        if birthday_period_packed?
          birthday_period = unpackBirthdayPeriod(birthday_period_packed)
          birthday_period.day_scroll_to = birthday_period.day_offset_start if birthday_period.day_offset_start?
          birthday_period
        else
          {}

      else
        state

    else
      state
