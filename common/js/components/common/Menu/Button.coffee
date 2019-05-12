import React from 'react'
import PropTypes from 'prop-types'
import { connect } from 'react-redux'

import { openMenu } from '@actions/menu'


a = React.createFactory 'a'
span = React.createFactory 'span'


mapStateToProps = (state, ownProps) ->
  {}


mapDispatchToProps = (dispatch, ownProps) ->
  openMenu: ->
    dispatch(openMenu())


class MenuButton extends React.Component

  onClick: (event) ->
    event.preventDefault()
    @props.openMenu()


  render: ->
    a { className: 'menu-button-container', onClick: @onClick.bind(this), href: '#' },
      span { className: 'menu-button' },
        span { className: 'menu-button-stripe menu-button-stripe-1' }
        span { className: 'menu-button-stripe menu-button-stripe-2' }
        span { className: 'menu-button-stripe menu-button-stripe-3' }

export default connect(mapStateToProps, mapDispatchToProps)(MenuButton)
