import { push, replace } from 'connected-react-router'
import { isEqual } from 'lodash'
import { isDefaultLayout, packLayout } from '@lib/layout'
import { isDefaultResultsSource, packResultsSource } from '@lib/search'
import { isEqualBirthdayPeriod, isPresentBirthdayPeriod, prevBirthdayPeriod, packBirthdayPeriod } from '@lib/birthdays'


import {
  URL_PARAM_UNIT
  URL_PARAM_EMPLOYMENT
  URL_PARAM_CONTACT
  URL_PARAM_LAYOUT
  URL_PARAM_RESULTS_SOURCE
  URL_PARAM_BIRTHDAY_PERIOD
} from '@constants/url-parsing'


prev_unit_id = prev_employment_id = prev_contact_id = prev_birthday_period = prev_results_source = undefined
prev_layout = []

prev_pushed_at = null

export default (store) ->
  store.subscribe ->
    state = store.getState()

    path_components = []

    unit_id = state.current?.unit_id
    employment_id = state.current?.employment_id
    contact_id = state.current?.contact_id
    birthday_period = state.birthday_period
    layout = state.layout?.pile
    results_source = state.search?.results_source

    if unit_id != prev_unit_id or employment_id != prev_employment_id or contact_id != prev_contact_id or
    !isEqualBirthdayPeriod(birthday_period, prev_birthday_period) or
    !isEqual(layout, prev_layout) or
    results_source != prev_results_source

      prev_unit_id = unit_id
      path_components.push "#{URL_PARAM_UNIT}-#{unit_id}" if unit_id?

      prev_employment_id = employment_id
      path_components.push "#{URL_PARAM_EMPLOYMENT}-#{employment_id}" if employment_id?

      prev_contact_id = contact_id
      path_components.push "#{URL_PARAM_CONTACT}-#{contact_id}" if contact_id?

      prev_birthday_period = prevBirthdayPeriod(birthday_period)
      path_components.push "#{URL_PARAM_BIRTHDAY_PERIOD}-#{packBirthdayPeriod(birthday_period)}" if isPresentBirthdayPeriod(birthday_period)

      prev_layout = layout
      path_components.push "#{URL_PARAM_LAYOUT}-#{packLayout(layout)}" unless isDefaultLayout(layout)

      prev_results_source = results_source
      path_components.push "#{URL_PARAM_RESULTS_SOURCE}-#{packResultsSource(results_source)}" unless isDefaultResultsSource(results_source)

      new_path = '/' + path_components.join('/')
      if new_path != state.router.location.pathname
        now = new Date()
        action = if prev_pushed_at? and now - prev_pushed_at < 500 then replace else push
        store.dispatch(action(new_path))
        prev_pushed_at = now
