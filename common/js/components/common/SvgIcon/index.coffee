import React from 'react'
import PropTypes from 'prop-types'

span = React.createFactory('span')


class SvgIcon extends React.Component
  @propTypes =
    svg: PropTypes.string
    className: PropTypes.string


  render: ->
    span { className: @props.className, dangerouslySetInnerHTML: { __html: @props.svg } }


export default SvgIcon
