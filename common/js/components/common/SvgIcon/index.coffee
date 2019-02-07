import React from 'react'
import PropTypes from 'prop-types'

span = React.createFactory('span')


class SvgIcon extends React.Component
  @propTypes =
    svg: PropTypes.string
    className: PropTypes.string
    onClick: PropTypes.func


  render: ->
    span { className: @props.className, dangerouslySetInnerHTML: { __html: @props.svg }, onClick: @props.onClick }


export default SvgIcon
