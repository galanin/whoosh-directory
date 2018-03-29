import React from 'react'
import PropTypes from 'prop-types'
import classNames from 'classnames'

class ToolbarButton extends React.Component
  render: ->
    class_name = classNames
      'toolbar-button': true
      'current-tool': this.props.current
    `<a className={class_name} href={this.props.href}>
        <img className="icon" src={this.props.icon} />
        <div className="label">{this.props.label}</div>
    </a>`

export default ToolbarButton
