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

  new_offsets
