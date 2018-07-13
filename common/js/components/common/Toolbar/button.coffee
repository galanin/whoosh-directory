import React from 'react'
import PropTypes from 'prop-types'
import classNames from 'classnames'
import InlineSVG from 'svg-inline-react'

a = React.createFactory('a')
div = React.createFactory('div')
svg = React.createFactory(InlineSVG)


class ToolbarButton extends React.Component

  render: ->

    class_name = classNames
      'toolbar-button': true
      'current-tool': this.props.current

    a { className: class_name, href: @props.href },
      svg { src: require('./icons/' + @props.file) }
      div { className: 'label' },
        @props.label


export default ToolbarButton
