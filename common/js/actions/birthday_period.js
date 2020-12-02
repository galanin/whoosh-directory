import {
  SET_BIRTHDAY_PERIOD,
  SET_BIRTHDAY_PERIOD_BY_DATE,
  EXTEND_BIRTHDAY_PERIOD_LEFT,
  EXTEND_BIRTHDAY_PERIOD_RIGHT,
  SCROLLED_TO_DATE
} from '@constants/birthday_period';

import { getOffsetsByShortcut } from '@lib/birthdays';

export const setBirthdayPeriodByShortcut = shortcut => (dispatch, getState) => {
  const [day_offset_left, day_offset_right] = getOffsetsByShortcut(shortcut);
  return dispatch(
    setBirthdayPeriod('today', day_offset_left, day_offset_right)
  );
};

export const setBirthdayPeriod = (
  key_date,
  day_offset_left,
  day_offset_right
) => ({
  type: SET_BIRTHDAY_PERIOD,
  key_date,
  day_offset_left,
  day_offset_right,
  day_offset_start: day_offset_left,
  day_scroll_to: day_offset_left
});

export const extendBirthdayPeriodLeft = days => ({
  type: EXTEND_BIRTHDAY_PERIOD_LEFT,
  days
});

export const extendBirthdayPeriodRight = days => ({
  type: EXTEND_BIRTHDAY_PERIOD_RIGHT,
  days
});

export const setBirthdayPeriodByInterval = (date1, date2) => ({
  type: SET_BIRTHDAY_PERIOD_BY_DATE,
  date1,
  date2
});

export const scrolledToDate = () => ({
  type: SCROLLED_TO_DATE
});
