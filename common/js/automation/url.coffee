import { push, replace } from 'connected-react-router'
import { isEqual } from 'lodash'
import { isDefaultLayout, packLayout } from '@lib/layout'
import { isDefaultResultsSource, packResultsSource, packQuery } from '@lib/search'
import { isEqualBirthdayPeriod, isPresentBirthdayPeriod, prevBirthdayPeriod, packBirthdayPeriod } from '@lib/birthdays'


import {
  URL_PARAM_UNIT
  URL_PARAM_EMPLOYMENT
  URL_PARAM_CONTACT
  URL_PARAM_LAYOUT
  URL_PARAM_RESULTS_SOURCE
  URL_PARAM_BIRTHDAY_PERIOD
  URL_PARAM_QUERY
} from '@constants/url-parsing'


prev_unit_id = prev_employment_id = prev_contact_id = prev_birthday_period = prev_results_source = prev_pushed_at = undefined
prev_query = ''
prev_layout = []

export default (store) ->
  store.subscribe ->
    state = store.getState()

    changed_params = []

    unit_id = state.current?.unit_id
    changed_params.push 'unit_id' if unit_id != prev_unit_id

    employment_id = state.current?.employment_id
    changed_params.push 'employment_id' if employment_id != prev_employment_id

    contact_id = state.current?.contact_id
    changed_params.push 'contact_id' if contact_id != prev_contact_id

    birthday_period = state.birthday_period
    changed_params.push 'birthday_period' if !isEqualBirthdayPeriod(birthday_period, prev_birthday_period)

    layout = state.layout?.pile
    changed_params.push 'layout' if !isEqual(layout, prev_layout)

    results_source = state.search?.results_source
    changed_params.push 'results_source' if results_source != prev_results_source

    query = state.search?.current_machine_query
    changed_params.push 'query' if query != prev_query

    if changed_params.length > 0

      path_components = []

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

      query_edited = changed_params.indexOf('query') >= 0 and prev_query.length > 0
      prev_query = query
      path_components.push "#{URL_PARAM_QUERY}-#{packQuery(query)}" if query.length > 0

      new_path = decodeURI('/' + path_components.join('/'))

      if new_path != state.router.location.pathname
        now = new Date()
        recently_changed = prev_pushed_at? and now - prev_pushed_at < 500
        go_through = !query_edited and recently_changed
        action = if go_through or query_edited then replace else push
        store.dispatch(action(new_path))
        prev_pushed_at = now
