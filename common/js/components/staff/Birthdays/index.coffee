import React from 'react'
import { connect } from 'react-redux'
import { isArray } from 'lodash'
import { Element as ScrollElement, scroller } from 'react-scroll'

import { dateByDayNumber } from '@lib/datetime'
import { getDayNumberByOffset, getBirthdayPeriodDates } from '@lib/birthdays'
import { scrolledToDate, extendBirthdayPeriodRight, extendBirthdayPeriodLeft } from '@actions/birthday_period'

div = React.createFactory('div')
scroll_element = React.createFactory(ScrollElement)

import Employee from '@components/staff/Employee'
employee = React.createFactory(Employee)

import Contact from '@components/staff/Contact'
contact = React.createFactory(Contact)


mapStateToProps = (state, ownProps) ->
  do_scroll = state.birthday_period.day_scroll_to?
  if do_scroll
    scroll_to_day_offset = state.birthday_period.day_scroll_to
    scroll_to_day_number = getDayNumberByOffset(state.birthday_period.key_date, scroll_to_day_offset)
    scroll_to_date = dateByDayNumber(scroll_to_day_number)
    do_scroll &&= state.birthdays[scroll_to_date]?

  birthday_period: state.birthday_period
  birthdays: state.birthdays
  do_scroll: do_scroll
  scroll_to: scroll_to_date

mapDispatchToProps = (dispatch) ->
  scrolledToDate: ->
    dispatch(scrolledToDate())
  stepForward: ->
    dispatch(extendBirthdayPeriodRight(7))
  stepBackward: ->
    dispatch(extendBirthdayPeriodLeft(7))


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


  stepForward: ->
    @props.stepForward()


  stepBackward: ->
    @props.stepBackward()


  render: ->
    return '' unless @props.birthday_period.key_date?

    dates = getBirthdayPeriodDates(@props.birthday_period)
    prev_date_offset_left = dateByDayNumber(getDayNumberByOffset(@props.birthday_period.key_date, @props.birthday_period.prev_day_offset_left))

    div { className: 'birthdays__scroller plug', id: 'birthdays-scroller' },
      div { className: 'birthdays' },
        div { className: 'birthdays__title' },
          'Дни рождения'

        for date in dates
          day_obj = @props.birthdays[date]

          if day_obj?
            div { className: 'birthdays__date', key: date },
              div { className: 'birthdays__date-head' },
                scroll_element { className: 'birthdays__date-title', name: "date-#{date}" },
                  day_obj.date_formatted
                if date == dates[0] or date == prev_date_offset_left
                  div { className: 'birthdays__button-backward', onClick: @stepBackward.bind(this) },
                    'Предыдущая неделя'

              if isArray(day_obj.results) and day_obj.results.length > 0
                div { className: 'birthdays__results' },
                  for result in day_obj.results
                    if result.contact_id?
                      contact(key: result.contact_id, contact_id: result.contact_id)
                    else if result.person_id?
                      employee key: result.person_id, employment_id: result.employ_ids[0], hide: { birthday: true }, className: 'list-item shadow'

        div { className: 'birthdays__button-forward', onClick: @stepForward.bind(this) },
          'Смотреть дальше'


export default connect(mapStateToProps, mapDispatchToProps)(Birthdays)
