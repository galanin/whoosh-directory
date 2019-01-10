import { padNumber } from '@lib/number'


export formatDayTime = (hours, minutes) ->
  padNumber(hours) + ':' + padNumber(minutes)


export formatDate = (month, day) ->
  padNumber(month + 1) + '-' + padNumber(day + 1)


MONTH_DAYS = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

MONTH_OFFSET = [0]
MONTH_OFFSET[i + 1] = MONTH_OFFSET[i] + MONTH_DAYS[i] for i in [0..10]

PLAIN_CALENDAR = []

fillMonth = (month_number) ->
  PLAIN_CALENDAR[MONTH_OFFSET[month_number] + day_number] = formatDate(month_number, day_number) for day_number in [0 .. MONTH_DAYS[month_number] - 1]

fillMonth(month_number) for month_number in [0..11]


export currentTime = ->
  now = new Date()
  formatDayTime(now.getHours(), now.getMinutes())


export todayDay = ->
  now = new Date()
  MONTH_OFFSET[now.getMonth()] + now.getDate() - 1


export todayDate = ->
  dateByDayNumber(todayDay())


correctDayNumber = (day_number) ->
  if day_number < 0
    366 + day_number
  else if day_number >= 366
    day_number - 366
  else
    day_number


export dateByDayNumber = (day_number) ->
  PLAIN_CALENDAR[correctDayNumber(day_number)]


export dayNumberByDate = (date) ->
  PLAIN_CALENDAR.indexOf(date)
