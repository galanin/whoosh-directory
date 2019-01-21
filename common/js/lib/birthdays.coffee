import { todayDay, dayNumberByDate, dateByDayNumber } from '@lib/datetime'


export limitExtension = (offsets, days) ->
  max_extension = 365 - (offsets.day_offset_right - offsets.day_offset_left)
  Math.min(max_extension, days)


export getOffsetsByShortcut = (period_shortcut) ->
  switch period_shortcut
    when 'today'
      [0, 0]

    when 'tomorrow'
      [1, 6]

    when 'recent'
      [-3, -1]


export getOffsetsByInterval = (date1, date2) ->
  left_day_number = dayNumberByDate(date1)
  right_day_number = dayNumberByDate(date2)
  right_day_number += 366 if right_day_number < left_day_number
  [left_day_number, right_day_number - left_day_number]


export getDayNumberByOffset = (key_date, offset) ->
  key_day = if key_date == 'today' then todayDay() else key_date
  key_day + offset


export getBirthdayIntervalDates = (date1, date2) ->
  left_day_number = dayNumberByDate(date1)
  right_day_number = dayNumberByDate(date2)
  getBirthdayOffsetsDates(left_day_number, right_day_number)


export getBirthdayPeriodDates = (offsets) ->
  left_day_number = getDayNumberByOffset(offsets.key_date, offsets.day_offset_left)
  right_day_number = getDayNumberByOffset(offsets.key_date, offsets.day_offset_right)
  getBirthdayOffsetsDates(left_day_number, right_day_number)


export getBirthdayOffsetsDates = (left_day_number, right_day_number) ->
  right_day_number += 366 if right_day_number < left_day_number
  dateByDayNumber(day_number) for day_number in [left_day_number..right_day_number]


isSuccessiveOffsets = (offsets1, offsets2) ->
  offsets1.day_offset_right + 1 == offsets2.day_offset_left


isIntersectedOffsets = (offset1, offset2) ->
  offset1.day_offset_left <= offset2.day_offset_left <= offset1.day_offset_right or
    offset1.day_offset_left <= offset2.day_offset_right <= offset1.day_offset_right


getUnsafeOffsetUnion = (offsets1, offsets2) ->
  if isSuccessiveOffsets(offsets1, offsets2)
    day_offset_left: offsets1.day_offset_left
    day_offset_right: offsets2.day_offset_right
  else if isSuccessiveOffsets(offsets2, offsets1)
    day_offset_left: offsets2.day_offset_left
    day_offset_right: offsets1.day_offset_right
  else if isIntersectedOffsets(offsets1, offsets2)
    day_offset_left: Math.min(offsets1.day_offset_left, offsets2.day_offset_left)
    day_offset_right: Math.max(offsets1.day_offset_right, offsets2.day_offset_right)
  else
    offsets2


export getOffsetsUnion = (offsets1, offsets2) ->
  new_offsets = getUnsafeOffsetUnion(offsets1, offsets2)
  if new_offsets.day_offset_right - new_offsets.day_offset_left >= 366
    if offsets2.day_offset_right > offsets1.day_offset_right
      new_offsets.day_offset_left = new_offsets.day_offset_right - 365
    else
      new_offsets.day_offset_right = new_offsets.day_offset_left + 365

  new_offsets.key_date = offsets1.key_date
  new_offsets.day_offset_start = offsets2.day_offset_left
  new_offsets.day_offset_start = Math.max(new_offsets.day_offset_start, new_offsets.day_offset_left)
  new_offsets.day_offset_start = Math.min(new_offsets.day_offset_start, new_offsets.day_offset_right)
  new_offsets.day_scroll_to = new_offsets.day_offset_start

  new_offsets


export isEqualBirthdayPeriod = (period1, period2) ->
  !period1? and !period2? or
  period1? and period2? and
  period1.key_date == period2.key_date and
  period1.day_offset_left == period2.day_offset_left and
  period1.day_offset_right == period2.day_offset_right and
  period1.day_offset_start == period2.day_offset_start


export isPresentBirthdayPeriod = (period) ->
  period? and period.key_date? and period.day_offset_left? and period.day_offset_right? and period.day_offset_start?


export prevBirthdayPeriod = (period) ->
  Object.assign({}, period)


export packBirthdayPeriod = (period) ->
  start = period.day_offset_start.toString().replace('-', '_')
  left = period.day_offset_left.toString().replace('-', '_')
  right = period.day_offset_right.toString().replace('-', '_')
  "#{period.key_date}-#{start}-#{left}-#{right}"


export unpackBirthdayPeriod = (str) ->
  period_arr = str.split('-')
  start = +period_arr[1].replace('_', '-')
  left = +period_arr[2].replace('_', '-')
  right = +period_arr[3].replace('_', '-')
  if period_arr[0]? and start? and left? and right? and !isNaN(start) and !isNaN(left) and !isNaN(right)
    key_date:         period_arr[0]
    day_offset_left:  left
    day_offset_right: right
    day_offset_start: start
  else
    {}
