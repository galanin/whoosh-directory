import React from 'react'
import { connect } from 'react-redux'
import classNames from 'classnames'
import { isArray } from 'lodash'

import { RESULTS_SOURCE_QUERY } from '@constants/search'

import { setQuery } from '@actions/search'
import { setResultsSource } from '@actions/search'
import { popSearchResults } from '@actions/layout'

div = React.createFactory('div')
span = React.createFactory('span')


mapStateToProps = (state, ownProps) ->
  {}


mapDispatchToProps = (dispatch, ownProps) ->
  onClick: (phone) ->
    dispatch(setQuery(new String(phone)))
    dispatch(setResultsSource(RESULTS_SOURCE_QUERY))
    dispatch(popSearchResults())


class Phones extends React.Component
  onClick: (phone) ->
    @props.onClick(phone[0])


  render: ->
    return '' unless (isArray(@props.format_phones) and @props.format_phones.length > 0)

    classes =
      'contact-data-phones' : true
    classes[@props.className] = true

    div { className: classNames(classes) },
      div { className: 'contact-data-phones__title' },
        if @props.format_phones.length == 1
          'Телефон'
        else
          'Телефоны'

      div { className: 'contact-data-phones__phones' },
        for phone in @props.format_phones
          div { className: 'contact-data-phones__phone', key: phone, onClick: @onClick.bind(this, phone) },
            span { className: 'contact-data-phones__phone-label' },
              phone[2] + ' '
            span { className: 'contact-data-phones__phone-number' },
              phone[1]


export default connect(mapStateToProps, mapDispatchToProps)(Phones)
