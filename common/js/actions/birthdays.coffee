MAX_BIRTHDAYS_AT_ONCE = 10

import { join, reject } from 'lodash'
import { Request } from '@lib/request'

import { SET_BIRTHDAY_RESULTS } from '@constants/birthdays'
import { setResultsType } from '@actions/search'
import { getOffsetsByShortcut, getBirthdayPeriodDates, getBirthdayIntervalDates } from '@lib/birthdays'
import { setBirthdayPeriod } from '@actions/birthday_period'
import { addPeople } from '@actions/people'
import { addEmployments } from '@actions/employments'
import { addContacts } from '@actions/contacts'


getMissingDates = (getState, required_dates) ->
  birthdays = getState().birthdays
  reject(required_dates, (o) -> birthdays[o]?)


export showBirthdayShortcutPeriod = (period_shortcut) ->
  (dispatch, getState) ->
    [day_offset_left, day_offset_right] = getOffsetsByShortcut(period_shortcut)
    dispatch(setBirthdayPeriod('today', day_offset_left, day_offset_right))
    dispatch(setResultsType('birthday'))
    dispatch(loadCurrentBirthdays())


export loadCurrentBirthdays = ->
  (dispatch, getState) ->
    dates = getBirthdayPeriodDates(getState().birthday_period)
    dispatch(loadBirthdaysByDatesAccelerated(dates))


export loadBirthdaysByInterval = (date1, date2) ->
  (dispatch, getState) ->
    dates = getBirthdayIntervalDates(date1, date2)
    dispatch(loadBirthdaysByDates(dates))


export loadBirthdaysByDates = (dates) ->
  (dispatch, getState) ->
    dispatch(loadMissingBirthdays(dates))


export loadBirthdaysByDatesAccelerated = (dates) ->
  (dispatch, getState) ->
    first_date = getMissingDates(getState, dates[0 .. 0])
    remaining_dates = getMissingDates(getState, dates[1 .. -1])
    dispatch(loadMissingBirthdays(first_date))
    dispatch(loadMissingBirthdays(remaining_dates))


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
