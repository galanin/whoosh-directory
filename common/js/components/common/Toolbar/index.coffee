import React from 'react'
import PropTypes from 'prop-types'

div = React.createFactory 'div'

import ToolbarButton from './button'
toolbar_button = React.createFactory(ToolbarButton)

#import SVGInline from "react-svg-inline"
import Logo from "./icons/logo-white.svg"
import Phonebook from "./icons/phonebook.svg"

#logo = React.createFactory(Logo)
#phonebook = React.createFactory(Phonebook)

buttons =
  portal:
    key:  'logo'
    href: 'http://portal'
    file: 'logo-white.svg'
    label: 'Портал'
  staff:
    key:  'staff'
    href: 'http://staff'
    file: 'phonebook.svg'
    label: 'Справочник сотрудников'
    current: true


class Toolbar extends React.Component

  render: ->
    current = @props.current_tool

    div { className: 'toolbar plug' },
      for key, button of buttons
        toolbar_button button


export default Toolbar
