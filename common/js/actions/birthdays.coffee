import { join, reject } from 'lodash'
import { Request } from '@lib/request'

import { SET_BIRTHDAY_RESULTS } from '@constants/birthdays'
import { getOffsetsByShortcut, getBirthdayPeriodDates } from '@lib/birthdays'
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


export loadBirthdays = ->
  (dispatch, getState) ->
    dates = getBirthdayPeriodDates(getState().birthday_period)
    missing_dates = getMissingDates(getState, dates)
    if missing_dates.length > 0
      dispatch(sendBirthdayQuery(missing_dates[0..0]))
      if missing_dates.length > 1
        setTimeout (-> dispatch(sendBirthdayQuery(missing_dates[1..-1]))), 1


export setBirthdayResults = (birthdays) ->
  type: SET_BIRTHDAY_RESULTS
  birthdays: birthdays


export sendBirthdayQuery = (days) ->
  (dispatch, getState) ->
    Request.get('/birthday/' + join(days, ',')).then (response) ->
      if response.body.people?
        dispatch(addPeople(response.body.people))
      if response.body.employments?
        dispatch(addEmployments(response.body.employments))
      if response.body.external_contacts?
        dispatch(addContacts(response.body.external_contacts))
      if response.body.results?
        dispatch(setBirthdayResults(response.body.results))
