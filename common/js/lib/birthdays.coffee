import { padStart } from 'lodash'

MONTH_DAYS = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

MONTH_OFFSET = [0]
MONTH_OFFSET[i + 1] = MONTH_OFFSET[i] + MONTH_DAYS[i] for i in [0..10]

PLAIN_CALENDAR = []

formatNumber = (number) ->
  number_str = number.toString()
  padStart(number_str, 2, '0')

formatDate = (month, day) ->
  formatNumber(month + 1) + '-' + formatNumber(day + 1)

fillMonth = (month_number) ->
  PLAIN_CALENDAR[MONTH_OFFSET[month_number] + day_number] = formatDate(month_number, day_number) for day_number in [0 .. MONTH_DAYS[month_number] - 1]

fillMonth(month_number) for month_number in [0..11]


getTodayDay = ->
  now = new Date()
  MONTH_OFFSET[now.getMonth()] + now.getDate() - 1


correctDayNumber = (day_number) ->
  if day_number < 0
    366 + day_number
  else if day_number >= 366
    day_number - 366
  else
    day_number


export getDateByDayNumber = (day_number) ->
  PLAIN_CALENDAR[correctDayNumber(day_number)]


export getDayNumberByDate = (date) ->
  PLAIN_CALENDAR.indexOf(date)


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
  key_day = if key_date == 'today' then getTodayDay() else key_date
  key_day + offset


export getBirthdayIntervalDates = (date1, date2) ->
  left_day_number = getDayNumberByDate(date1)
  right_day_number = getDayNumberByDate(date2)
  getBirthdayOffsetsDates(left_day_number, right_day_number)


export getBirthdayPeriodDates = (offsets) ->
  left_day_number = getDayNumberByOffset(offsets.key_date, offsets.day_offset_left)
  right_day_number = getDayNumberByOffset(offsets.key_date, offsets.day_offset_right)
  getBirthdayOffsetsDates(left_day_number, right_day_number)


export getBirthdayOffsetsDates = (left_day_number, right_day_number) ->
  right_day_number += 366 if right_day_number < left_day_number
  getDateByDayNumber(day_number) for day_number in [left_day_number..right_day_number]


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
