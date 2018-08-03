import React from 'react'
import PropTypes from 'prop-types'
import classNames from 'classnames'
import SvgIcon from '@components/common/SvgIcon'

a = React.createFactory('a')
div = React.createFactory('div')
svg = React.createFactory(SvgIcon)


class ToolbarButton extends React.Component

  render: ->

    class_name = classNames
      'toolbar-button': true
      'current-tool': this.props.current

    a { className: class_name, href: @props.href },
      svg { svg: @props.svg }
      div { className: 'label' },
        @props.label


export default ToolbarButton
