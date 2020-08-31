import React from 'react'
import classNames from 'classnames'
import SvgIcon from '@components/common/SvgIcon'

div = React.createFactory('div')
svg = React.createFactory(SvgIcon)

class IconedData extends React.Component

  render: ->
    classes =
      'iconed-data' : true
      'iconed-data_icon-align-top' : @props.align_icon == 'top'
      'iconed-data_icon-align-middle' : @props.align_icon == 'middle'
      'iconed-data_clickable' : !! @props.onClick
    classes[@props.className] = true

    div { className: classNames(classes), onClick: @props.onClick },
      svg { className: 'big-icon iconed-data__icon', svg: @props.icon }
      div { className: 'iconed-data__container' },
        div { className: 'iconed-data__data' },
          @props.children


export default IconedData
