/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import {
  SET_BIRTHDAY_PERIOD,
  SET_BIRTHDAY_PERIOD_BY_DATE,
  EXTEND_BIRTHDAY_PERIOD_LEFT,
  EXTEND_BIRTHDAY_PERIOD_RIGHT,
  SCROLLED_TO_DATE
} from '@constants/birthday_period';

import { getOffsetsByShortcut } from '@lib/birthdays';


export var setBirthdayPeriodByShortcut = shortcut => (function(dispatch, getState) {
  const [day_offset_left, day_offset_right] = Array.from(getOffsetsByShortcut(shortcut));
  return dispatch(setBirthdayPeriod('today', day_offset_left, day_offset_right));
});


export var setBirthdayPeriod = (key_date, day_offset_left, day_offset_right) => ({
  type: SET_BIRTHDAY_PERIOD,
  key_date,
  day_offset_left,
  day_offset_right,
  day_offset_start: day_offset_left,
  day_scroll_to: day_offset_left
});

export var extendBirthdayPeriodLeft = days => ({
  type: EXTEND_BIRTHDAY_PERIOD_LEFT,
  days
});


export var extendBirthdayPeriodRight = days => ({
  type: EXTEND_BIRTHDAY_PERIOD_RIGHT,
  days
});


export var setBirthdayPeriodByInterval = (date1, date2) => ({
  type: SET_BIRTHDAY_PERIOD_BY_DATE,
  date1,
  date2
});


export var scrolledToDate = () => ({
  type: SCROLLED_TO_DATE
});
