import { padStart } from 'lodash'

MONTH_DAYS = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
MONTH_OFFSET = [0]
MONTH_OFFSET[i + 1] = MONTH_OFFSET[i] + MONTH_DAYS[i] for i in [0..10]

PLAIN_CALENDAR = []
fillMonth = (month_number) ->
  PLAIN_CALENDAR[MONTH_OFFSET[month_number] + i] = { month: month_number, day: i } for i in [0..MONTH_DAYS[month_number]]
fillMonth(i) for i in [0..12]


getTodayObj = ->
  now = new Date()
  month: now.getMonth()
  day: now.getDate() - 1


getDayNumber = (date) ->
  MONTH_OFFSET[date.month] + date.day


correctDayNumber = (day_number) ->
  if day_number < 0
    366 + day_number
  else if day_number > 366
    day_number - 366
  else
    day_number


getDateObjFromDayNumber = (day_number) ->
  PLAIN_CALENDAR[day_number]


addDays = (date, days) ->
  getDateObjFromDayNumber(correctDayNumber(getDayNumber(date) + days))


subDates = (date_begin, date_end) ->
  day_begin = getDayNumber(date_begin)
  day_end = getDayNumber(date_end)
  correctDayNumber(day_begin - day_end)


getMaxExtension = (date_begin, date_end) ->
  delta = subDates(date_begin, date_end)
  365 - delta


limitExtension =  (date_begin, date_end, days) ->
  max_extension = getMaxExtension(date_begin, date_end)
  Math.min(max_extension, days)


formatNumber = (number) ->
  number_str = number.toString()
  padStart(number_str, 2, '0')


export formatDateObj = (date_obj) ->
  formatNumber(date_obj.month + 1) + '-' + formatNumber(date_obj.day + 1)


export getOffsetsByShortcut = (period_shortcut) ->
  switch period_shortcut
    when 'today'
      [0, 0]

    when 'tomorrow'
      [0, 6]

    when 'recent'
      [-2, -1]


export getBirthdayPeriodDates = (offsets) ->
  key_date_obj = if offsets.key_date == 'today' then getTodayObj() else offsets.key_date
  key_day = getDayNumber(key_date_obj)
  left_day = correctDayNumber(key_day + offsets.day_offset_left)
  right_day = correctDayNumber(key_day + offsets.day_offset_right)
  formatDateObj(getDateObjFromDayNumber(d)) for d in [left_day..right_day]


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


export extendPeriodLeft = (offsets, days) ->
  max_extension = limitExtension(date_begin, date_end, days)
  left = addDays(offsets.day_offset_left, -max_extension)
  key_date: offsets.key_date
  day_offset_left: left
  day_offset_right: offsets.day_offset_right
  day_offset_start: left


export extendPeriodRight = (offsets, days) ->
  max_extension = limitExtension(date_begin, date_end, days)
  right = addDays(offsets.day_offset_right, max_extension)
  key_date: offsets.key_date
  day_offset_left: offsets.day_offset_left
  day_offset_right: right
  day_offset_start: Math.min(right, offsets.day_offset_right + 1)
