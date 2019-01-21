import React from 'react'
import classNames from 'classnames'
import SvgIcon from '@components/common/SvgIcon'
import IconedData from '@components/contact_info/IconedData'

div = React.createFactory('div')
a = React.createFactory('a')
svg = React.createFactory(SvgIcon)
iconed_data = React.createFactory(IconedData)

import EmailIcon from '@icons/at-sign.svg'

class Email extends React.Component
  render: ->
    return '' unless @props.email?

    classes =
      'contact-data-email' : true
    classes[@props.className] = true

    iconed_data { className: classNames(classes), icon: EmailIcon, align_icon: 'middle' },
      div { className: 'iconed-data__row iconed-data__row-title' },
        'E-mail'
      div { className: 'iconed-data__row iconed-data__row-data' },
        a { className: 'iconed-data__row-data-value iconed-data__email-link', href: 'mailto:' + @props.email },
          @props.email


export default Email
