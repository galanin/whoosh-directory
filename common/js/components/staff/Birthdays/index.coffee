import React from 'react'
import { connect } from 'react-redux'
import { isArray } from 'lodash'
import { Element as ScrollElement, scroller } from 'react-scroll'

import { getDayNumberByOffset, formatDateObj, getDateObjFromDayNumber, getBirthdayPeriodDates } from '@lib/birthdays'
import { scrolledToDate } from '@actions/birthday_period'

div = React.createFactory('div')
scroll_element = React.createFactory(ScrollElement)

import Employee from '@components/staff/Employee'
employee = React.createFactory(Employee)

import Contact from '@components/staff/Contact'
contact = React.createFactory(Contact)


mapStateToProps = (state, ownProps) ->
  do_scroll = state.birthday_period.day_offset_start?
  if do_scroll
    scroll_to_day_offset = state.birthday_period.day_offset_start
    scroll_to_day_number = getDayNumberByOffset(state.birthday_period.key_date, scroll_to_day_offset)
    scroll_to_date = formatDateObj(getDateObjFromDayNumber(scroll_to_day_number))
    do_scroll &&= state.birthdays[scroll_to_date]?

  birthday_period: state.birthday_period
  birthdays: state.birthdays
  do_scroll: do_scroll
  scroll_to: scroll_to_date

mapDispatchToProps = (dispatch) ->
  scrolledToDate: ->
    dispatch(scrolledToDate())


class Birthdays extends React.Component

  componentDidUpdate: (prevProps) ->
    if @props.do_scroll
      scroller.scrollTo "date-#{@props.scroll_to}",
        offset:   -200
        duration:  200
        smooth:    true
        isDynamic: true
        containerId: 'birthdays-scroller'
      @props.scrolledToDate()


  render: ->
    return '' unless @props.birthday_period.key_date?

    dates = getBirthdayPeriodDates(@props.birthday_period)

    div { className: 'birthdays__scroller plug', id: 'birthdays-scroller' },
      div { className: 'birthdays' },
        div { className: 'birthdays__title' },
          'Дни рождения'

        for date in dates
          day_obj = @props.birthdays[date]

          if day_obj?
            div { className: 'birthdays__date', key: date },
              scroll_element { className: 'birthdays__date-title', name: "date-#{date}" },
                day_obj.date_formatted

              if isArray(day_obj.results) and day_obj.results.length > 0
                div { className: 'birthdays__results' },
                  for result in day_obj.results
                    if result.contact_id?
                      contact(key: result.contact_id, contact_id: result.contact_id)
                    else if result.person_id?
                      employee key: result.person_id, employment_id: result.employ_ids[0], className: 'list-item shadow'


export default connect(mapStateToProps, mapDispatchToProps)(Birthdays)
