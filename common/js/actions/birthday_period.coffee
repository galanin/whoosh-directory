import {
  SET_BIRTHDAY_PERIOD
  SET_BIRTHDAY_PERIOD_BY_DATE
  EXTEND_BIRTHDAY_PERIOD_LEFT
  EXTEND_BIRTHDAY_PERIOD_RIGHT
  SCROLLED_TO_DATE
} from '@constants/birthday_period'

import { getOffsetsByShortcut } from '@lib/birthdays'


export setBirthdayPeriodByShortcut = (shortcut) ->
  (dispatch, getState) ->
    [day_offset_left, day_offset_right] = getOffsetsByShortcut(shortcut)
    dispatch(setBirthdayPeriod('today', day_offset_left, day_offset_right))


export setBirthdayPeriod = (key_date, day_offset_left, day_offset_right) ->
  type: SET_BIRTHDAY_PERIOD
  key_date: key_date
  day_offset_left: day_offset_left
  day_offset_right: day_offset_right
  day_offset_start: day_offset_left
  day_scroll_to: day_offset_left

export extendBirthdayPeriodLeft = (days) ->
  type: EXTEND_BIRTHDAY_PERIOD_LEFT
  days: days


export extendBirthdayPeriodRight = (days) ->
  type: EXTEND_BIRTHDAY_PERIOD_RIGHT
  days: days


export setBirthdayPeriodByInterval = (date1, date2) ->
  type: SET_BIRTHDAY_PERIOD_BY_DATE
  date1: date1
  date2: date2


export scrolledToDate = ->
  type: SCROLLED_TO_DATE
