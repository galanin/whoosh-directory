import {
  SET_BIRTHDAY_PERIOD
  EXTEND_BIRTHDAY_PERIOD_LEFT
  EXTEND_BIRTHDAY_PERIOD_RIGHT
  SCROLLED_TO_DATE
} from '@constants/birthday_period'


export setBirthdayPeriod = (key_date, day_offset_left, day_offset_right) ->
  type: SET_BIRTHDAY_PERIOD
  key_date: key_date
  day_offset_left: day_offset_left
  day_offset_right: day_offset_right
  day_offset_start: day_offset_left


export extendBirthdayPeriodLeft = (days) ->
  type: EXTEND_BIRTHDAY_PERIOD_LEFT
  days: days


export extendBirthdayPeriodRight = (days) ->
  type: EXTEND_BIRTHDAY_PERIOD_RIGHT
  days: days


export scrolledToDate = ->
  type: SCROLLED_TO_DATE
