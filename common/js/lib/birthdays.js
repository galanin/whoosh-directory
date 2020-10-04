import { todayDay, dayNumberByDate, dateByDayNumber } from '@lib/datetime';

export const limitExtension = (offsets, days) => {
  const max_extension =
    365 - (offsets.day_offset_right - offsets.day_offset_left);
  return Math.min(max_extension, days);
};

export const getOffsetsByShortcut = period_shortcut => {
  switch (period_shortcut) {
    case 'today':
      return [0, 0];

    case 'tomorrow':
      return [1, 6];

    case 'recent':
      return [-3, -1];
  }
};

export const getOffsetsByInterval = (date1, date2) => {
  const left_day_number = dayNumberByDate(date1);
  let right_day_number = dayNumberByDate(date2);
  if (right_day_number < left_day_number) {
    right_day_number += 366;
  }
  return [left_day_number, right_day_number - left_day_number];
};

export const getDayNumberByOffset = (key_date, offset) => {
  const key_day = key_date === 'today' ? todayDay() : key_date;
  return key_day + offset;
};

export const getBirthdayIntervalDates = (date1, date2) => {
  const left_day_number = dayNumberByDate(date1);
  const right_day_number = dayNumberByDate(date2);
  return getBirthdayOffsetsDates(left_day_number, right_day_number);
};

export const getBirthdayPeriodDates = offsets => {
  const left_day_number = getDayNumberByOffset(
    offsets.key_date,
    offsets.day_offset_left
  );
  const right_day_number = getDayNumberByOffset(
    offsets.key_date,
    offsets.day_offset_right
  );
  return getBirthdayOffsetsDates(left_day_number, right_day_number);
};

export const getBirthdayOffsetsDates = (left_day_number, right_day_number) => {
  if (right_day_number < left_day_number) {
    right_day_number += 366;
  }
  return __range__(left_day_number, right_day_number, true).map(day_number =>
    dateByDayNumber(day_number)
  );
};

const isSuccessiveOffsets = (offsets1, offsets2) =>
  offsets1.day_offset_right + 1 === offsets2.day_offset_left;

const isIntersectedOffsets = (offset1, offset2) =>
  (offset1.day_offset_left <= offset2.day_offset_left &&
    offset2.day_offset_left <= offset1.day_offset_right) ||
  (offset1.day_offset_left <= offset2.day_offset_right &&
    offset2.day_offset_right <= offset1.day_offset_right);

const getUnsafeOffsetUnion = (offsets1, offsets2) => {
  if (isSuccessiveOffsets(offsets1, offsets2)) {
    return {
      day_offset_left: offsets1.day_offset_left,
      day_offset_right: offsets2.day_offset_right
    };
  } else if (isSuccessiveOffsets(offsets2, offsets1)) {
    return {
      day_offset_left: offsets2.day_offset_left,
      day_offset_right: offsets1.day_offset_right
    };
  } else if (isIntersectedOffsets(offsets1, offsets2)) {
    return {
      day_offset_left: Math.min(
        offsets1.day_offset_left,
        offsets2.day_offset_left
      ),
      day_offset_right: Math.max(
        offsets1.day_offset_right,
        offsets2.day_offset_right
      )
    };
  } else {
    return offsets2;
  }
};

export const getOffsetsUnion = (offsets1, offsets2) => {
  const new_offsets = getUnsafeOffsetUnion(offsets1, offsets2);
  if (new_offsets.day_offset_right - new_offsets.day_offset_left >= 366) {
    if (offsets2.day_offset_right > offsets1.day_offset_right) {
      new_offsets.day_offset_left = new_offsets.day_offset_right - 365;
    } else {
      new_offsets.day_offset_right = new_offsets.day_offset_left + 365;
    }
  }

  new_offsets.key_date = offsets1.key_date;
  new_offsets.day_offset_start = offsets2.day_offset_left;
  new_offsets.day_offset_start = Math.max(
    new_offsets.day_offset_start,
    new_offsets.day_offset_left
  );
  new_offsets.day_offset_start = Math.min(
    new_offsets.day_offset_start,
    new_offsets.day_offset_right
  );
  new_offsets.day_scroll_to = new_offsets.day_offset_start;

  return new_offsets;
};

export const isEqualBirthdayPeriod = (period1, period2) =>
  (!period1 && !period2) ||
  (period1 &&
    period2 &&
    period1.key_date === period2.key_date &&
    period1.day_offset_left === period2.day_offset_left &&
    period1.day_offset_right === period2.day_offset_right &&
    period1.day_offset_start === period2.day_offset_start);

export const isPresentBirthdayPeriod = period =>
  period &&
  period.key_date &&
  period.day_offset_left &&
  period.day_offset_right &&
  period.day_offset_start;

export const prevBirthdayPeriod = period => Object.assign({}, period);

export const packBirthdayPeriod = period => {
  const start = period.day_offset_start.toString().replace('-', '_');
  const left = period.day_offset_left.toString().replace('-', '_');
  const right = period.day_offset_right.toString().replace('-', '_');
  return `${period.key_date}-${start}-${left}-${right}`;
};

export const unpackBirthdayPeriod = str => {
  const period_arr = str.split('-');
  const start = +period_arr[1].replace('_', '-');
  const left = +period_arr[2].replace('_', '-');
  const right = +period_arr[3].replace('_', '-');
  if (
    period_arr[0] &&
    start &&
    left &&
    right &&
    !isNaN(start) &&
    !isNaN(left) &&
    !isNaN(right)
  ) {
    return {
      key_date: period_arr[0],
      day_offset_left: left,
      day_offset_right: right,
      day_offset_start: start
    };
  } else {
    return {};
  }
};

function __range__(left, right, inclusive) {
  let range = [];
  let ascending = left < right;
  let end = !inclusive ? right : ascending ? right + 1 : right - 1;
  for (let i = left; ascending ? i < end : i > end; ascending ? i++ : i--) {
    range.push(i);
  }
  return range;
}
