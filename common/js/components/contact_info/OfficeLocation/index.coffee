import React from 'react'
import classNames from 'classnames'
import SvgIcon from '@components/common/SvgIcon'
import IconedData from '@components/contact_info/IconedData'

div = React.createFactory('div')
span = React.createFactory('span')
svg = React.createFactory(SvgIcon)
iconed_data = React.createFactory(IconedData)

import LocationIcon from '@icons/location.svg'

class OfficeLocation extends React.Component
  render: ->
    return '' unless @props.building? or @props.office?

    classes =
      'contact-data-office-location' : true
    classes[@props.className] = true

    iconed_data { className: classNames(classes), icon: LocationIcon, align_icon: 'middle' },
      if @props.building?
        div { className: 'iconed-data__row iconed-data__inline' },
          span { className: 'iconed-data__inline-title' },
            'Корпус '
          span { className: 'iconed-data__inline-data' },
            @props.building
      if @props.office?
        div { className: 'iconed-data__row iconed-data__inline' },
          span { className: 'iconed-data__inline-title' },
            'Кабинет '
          span { className: 'iconed-data__inline-data' },
            @props.office


export default OfficeLocation