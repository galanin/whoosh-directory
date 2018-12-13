import React from 'react'
import classNames from 'classnames'
import { isArray } from 'lodash'

div = React.createFactory('div')
span = React.createFactory('span')


class Phones extends React.Component
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
          div { className: 'contact-data-phones__phone', key: phone },
            span { className: 'contact-data-phones__phone-label' },
              phone[2] + ' '
            span { className: 'contact-data-phones__phone-number' },
              phone[1]


export default Phones
