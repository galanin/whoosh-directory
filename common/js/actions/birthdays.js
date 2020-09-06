/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const MAX_BIRTHDAYS_AT_ONCE = 10;

import { join, reject, difference } from 'lodash';
import { Request } from '@lib/request';

import { SET_BIRTHDAY_RESULTS } from '@constants/birthdays';
import { setResultsType } from '@actions/search';
import { dateByDayNumber } from '@lib/datetime';
import { getDayNumberByOffset, getOffsetsByShortcut, getOffsetsByInterval, getBirthdayPeriodDates, getBirthdayIntervalDates } from '@lib/birthdays';
import { setBirthdayPeriod } from '@actions/birthday_period';
import { addPeople } from '@actions/people';
import { addEmployments } from '@actions/employments';
import { addContacts } from '@actions/contacts';


const getMissingDates = function(getState, required_dates) {
  const {
    birthdays
  } = getState();
  return reject(required_dates, o => birthdays[o] != null);
};


export var loadCurrentBirthdays = () => (function(dispatch, getState) {
  const state = getState();

  const start_day_number = getDayNumberByOffset(state.birthday_period.key_date, state.birthday_period.day_offset_start);
  const start_date = dateByDayNumber(start_day_number);
  dispatch(loadMissingBirthdays([start_date]));

  return setTimeout(function() {
    let dates = getBirthdayPeriodDates(getState().birthday_period);
    dates = difference(dates, [start_date]);
    return dispatch(loadMissingBirthdays(dates));
  }
    , 10);
});


var loadMissingBirthdays = dates => (function(dispatch, getState) {
  const missing_dates = getMissingDates(getState, dates);
  return dispatch(loadBirthdays(missing_dates));
});


var loadBirthdays = dates => (function(dispatch, getState) {
  const dates1 = dates.slice(0 , + (MAX_BIRTHDAYS_AT_ONCE - 1) + 1 || undefined);
  const dates2 = dates.slice(MAX_BIRTHDAYS_AT_ONCE );
  if (dates1.length > 0) {
    return dispatch(loadBirthdaysAtOnce(dates1, function() {
      if (dates2.length > 0) {
        return dispatch(loadBirthdays(dates2));
      }
    }));
  }
});


export var setBirthdayResults = birthdays => ({
  type: SET_BIRTHDAY_RESULTS,
  birthdays
});


var loadBirthdaysAtOnce = (days, callback) => (dispatch, getState) => Request.get('/birthday/' + join(days, ',')).then(function(response) {
  if (response.body.people != null) {
    dispatch(addPeople(response.body.people));
  }
  if (response.body.employments != null) {
    dispatch(addEmployments(response.body.employments));
  }
  if (response.body.external_contacts != null) {
    dispatch(addContacts(response.body.external_contacts));
  }
  if (response.body.birthdays != null) {
    dispatch(setBirthdayResults(response.body.birthdays));
  }

  return (typeof callback === 'function' ? callback() : undefined);
});
