/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import { LOCATION_CHANGE } from 'connected-react-router';
import { getNewUrlParam } from '@lib/url-parsing';
import { URL_PARAM_BIRTHDAY_PERIOD } from '@constants/url-parsing';

import {
  SET_BIRTHDAY_PERIOD,
  SET_BIRTHDAY_PERIOD_BY_DATE,
  EXTEND_BIRTHDAY_PERIOD_LEFT,
  EXTEND_BIRTHDAY_PERIOD_RIGHT,
  SCROLLED_TO_DATE
} from '@constants/birthday_period';

import { dayNumberByDate } from '@lib/datetime';
import { limitExtension, getOffsetsUnion, getOffsetsByShortcut, unpackBirthdayPeriod } from '@lib/birthdays';


export default (function(state, action) {
  if (state == null) { state = {}; }
  switch (action.type) {

    case SET_BIRTHDAY_PERIOD:
      if (state.key_date !== action.key_date) {
        return {
          key_date:         action.key_date,
          day_offset_left:  action.day_offset_left,
          day_offset_right: action.day_offset_right,
          day_offset_start: action.day_offset_left,
          day_scroll_to:    action.day_offset_left
        };
      } else {
        return getOffsetsUnion(state, action);
      }

    case SET_BIRTHDAY_PERIOD_BY_DATE:
      var day1 = dayNumberByDate(action.date1);
      var day2 = dayNumberByDate(action.date2);
      if (day2 < day1) {
        day2 += 366;
      }
      return {
        key_date:         day1,
        day_offset_left:  0,
        day_offset_right: day2 - day1,
        day_offset_start: 0,
        day_scroll_to:    0
      };

    case EXTEND_BIRTHDAY_PERIOD_LEFT:
      var max_extension = limitExtension(state, action.days);
      var left = state.day_offset_left - max_extension;
    
      return {
        key_date:         state.key_date,
        day_offset_left:  left,
        day_offset_right: state.day_offset_right,
        day_offset_start: left,
        day_scroll_to:    left,
        prev_day_offset_left: state.day_offset_left
      };

    case EXTEND_BIRTHDAY_PERIOD_RIGHT:
      max_extension = limitExtension(state, action.days);
      var right = state.day_offset_right + max_extension;
      var start = Math.min(right, state.day_offset_right + 1);

      return {
        key_date:         state.key_date,
        day_offset_left:  state.day_offset_left,
        day_offset_right: right,
        day_offset_start: start,
        day_scroll_to:    start
      };

    case SCROLLED_TO_DATE:
      var new_state = Object.assign({}, state);
      delete new_state.day_scroll_to;
      return new_state;

    case LOCATION_CHANGE:
      if (action.payload.action === 'POP') {
        const birthday_period_packed = getNewUrlParam(action.payload, URL_PARAM_BIRTHDAY_PERIOD);
        if (birthday_period_packed != null) {
          const birthday_period = unpackBirthdayPeriod(birthday_period_packed);
          if (birthday_period.day_offset_start != null) { birthday_period.day_scroll_to = birthday_period.day_offset_start; }
          return birthday_period;
        } else {
          return {};
        }

      } else {
        return state;
      }

    default:
      return state;
  }
});
