import React from 'react'
import classNames from 'classnames'
import SvgIcon from '@components/common/SvgIcon'
import IconedData from '@components/contact_info/IconedData'

div = React.createFactory('div')
span = React.createFactory('span')
svg = React.createFactory(SvgIcon)
iconed_data = React.createFactory(IconedData)

import BirthdayIcon from '@icons/birthday.svg'

class Birthday extends React.Component
  render: ->
    return '' unless @props.birthday_formatted?

    classes =
      'contact-data-birthday' : true
      'contact-data_highlighted' : @props.highlighted
      'contact-data-birthday_highlighted' : @props.highlighted
    classes[@props.className] = true

    iconed_data { className: classNames(classes), icon: BirthdayIcon, align_icon: 'middle' },
      div { className: 'iconed-data__row iconed-data__row-title' },
        'День рождения'
      div { className: 'iconed-data__row iconed-data__row-data' },
        div { className: 'iconed-data__row-data-value' },
          @props.birthday_formatted


export default Birthday
