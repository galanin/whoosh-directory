MAX_BIRTHDAYS_AT_ONCE = 10

import { join, reject, difference } from 'lodash'
import { Request } from '@lib/request'

import { SET_BIRTHDAY_RESULTS } from '@constants/birthdays'
import { setResultsType } from '@actions/search'
import { dateByDayNumber } from '@lib/datetime'
import { getDayNumberByOffset, getOffsetsByShortcut, getOffsetsByInterval, getBirthdayPeriodDates, getBirthdayIntervalDates } from '@lib/birthdays'
import { setBirthdayPeriod } from '@actions/birthday_period'
import { addPeople } from '@actions/people'
import { addEmployments } from '@actions/employments'
import { addContacts } from '@actions/contacts'


getMissingDates = (getState, required_dates) ->
  birthdays = getState().birthdays
  reject(required_dates, (o) -> birthdays[o]?)


export loadCurrentBirthdays = ->
  (dispatch, getState) ->
    state = getState()

    start_day_number = getDayNumberByOffset(state.birthday_period.key_date, state.birthday_period.day_offset_start)
    start_date = dateByDayNumber(start_day_number)
    dispatch(loadMissingBirthdays([start_date]))

    setTimeout ->
      dates = getBirthdayPeriodDates(getState().birthday_period)
      dates = difference(dates, [start_date])
      dispatch(loadMissingBirthdays(dates))
    , 10


loadMissingBirthdays = (dates) ->
  (dispatch, getState) ->
    missing_dates = getMissingDates(getState, dates)
    dispatch(loadBirthdays(missing_dates))


loadBirthdays = (dates) ->
  (dispatch, getState) ->
    dates1 = dates[0 .. MAX_BIRTHDAYS_AT_ONCE - 1]
    dates2 = dates[MAX_BIRTHDAYS_AT_ONCE .. -1]
    if dates1.length > 0
      dispatch(loadBirthdaysAtOnce(dates1, ->
        if dates2.length > 0
          dispatch(loadBirthdays(dates2))
      ))


export setBirthdayResults = (birthdays) ->
  type: SET_BIRTHDAY_RESULTS
  birthdays: birthdays


loadBirthdaysAtOnce = (days, callback) ->
  (dispatch, getState) ->
    Request.get('/birthday/' + join(days, ',')).then (response) ->
      if response.body.people?
        dispatch(addPeople(response.body.people))
      if response.body.employments?
        dispatch(addEmployments(response.body.employments))
      if response.body.external_contacts?
        dispatch(addContacts(response.body.external_contacts))
      if response.body.birthdays?
        dispatch(setBirthdayResults(response.body.birthdays))

      callback?()
