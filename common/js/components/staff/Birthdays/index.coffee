import React from 'react'
import { connect } from 'react-redux'
import { isArray } from 'lodash'

import { getBirthdayPeriodDates } from '@lib/birthdays'

div = React.createFactory('div')

import Employee from '@components/staff/Employee'
employee = React.createFactory(Employee)

import Contact from '@components/staff/Contact'
contact = React.createFactory(Contact)


mapStateToProps = (state, ownProps) ->
  birthday_period: state.birthday_period
  birthdays: state.birthdays

mapDispatchToProps = (dispatch) ->
  {}


class Birthdays extends React.Component
  render: ->
    return '' unless @props.birthday_period.key_date?

    dates = getBirthdayPeriodDates(@props.birthday_period)

    div { className: 'birthdays__scroller plug' },
      div { className: 'birthdays' },
        div { className: 'birthdays__title' },
          'Дни рождения'

        for date in dates
          day_obj = @props.birthdays[date]

          if day_obj?
            div { className: 'birthdays__date', key: date },
              div { className: 'birthdays__date-title' },
                day_obj.date_formatted

              if isArray(day_obj.results) and day_obj.results.length > 0
                div { className: 'birthdays__results' },
                  for result in day_obj.results
                    if result.contact_id?
                      contact(key: result.contact_id, contact_id: result.contact_id)
                    else if result.person_id?
                      employee(key: result.person_id, employment_id: result.employ_ids[0])


export default connect(mapStateToProps, mapDispatchToProps)(Birthdays)
