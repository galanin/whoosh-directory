import React from 'react'
import PropTypes from 'prop-types'

div = React.createFactory 'div'

import ToolbarButton from './button'
toolbar_button = React.createFactory(ToolbarButton)

import Logo from "./icons/logo-white.svg"
import Phonebook from "./icons/phonebook.svg"


buttons =
  portal:
    key:  'logo'
    href: 'http://portal'
    svg:  Logo
    label: 'Портал'
  staff:
    key:  'staff'
    href: 'http://staff'
    svg:  Phonebook
    label: 'Справочник сотрудников'
    current: true


class Toolbar extends React.Component

  render: ->
    current = @props.current_tool

    div { className: 'toolbar plug' },
      for key, button of buttons
        toolbar_button button


export default Toolbar
