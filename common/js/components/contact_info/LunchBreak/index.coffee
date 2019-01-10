import React from 'react'
import classNames from 'classnames'
import SvgIcon from '@components/common/SvgIcon'
import IconedData from '@components/contact_info/IconedData'

div = React.createFactory('div')
span = React.createFactory('span')
svg = React.createFactory(SvgIcon)
iconed_data = React.createFactory(IconedData)

import LunchIcon from '@icons/lunch.svg'

class LunchBreak extends React.Component
  render: ->
    return '' unless (@props.lunch_begin? and @props.lunch_end?)

    classes =
      'contact-data-lunch-break' : true
      'contact-data_highlighted' : @props.highlighted
      'contact-data-lunch-break_highlighted' : @props.highlighted
    classes[@props.className] = true

    iconed_data { className: classNames(classes), icon: LunchIcon, align_icon: 'middle' },
      div { className: 'iconed-data__row iconed-data__row-title' },
        'Обеденный перерыв'
      div { className: 'iconed-data__row iconed-data__row-data' },
        div { className: 'iconed-data__row-data-value' },
          span { className: 'employee-info__lunch-begin' },
            @props.lunch_begin
          span { className: 'employee-info__lunch-separator' },
            '—'
          span { className: 'employee-info__lunch-end' },
            @props.lunch_end


export default LunchBreak
