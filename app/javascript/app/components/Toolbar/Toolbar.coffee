require './Toolbar.sass'

import React from 'react'
import PropTypes from 'prop-types'

div = React.createFactory('div')

import ToolbarButton from './ToolbarButton'
toolbar_button = React.createFactory(ToolbarButton)


import img_logo from './icons/logo-white.svg'
import img_phonebook from './icons/phonebook.svg'

buttons =
  portal:
    href: 'http://portal'
    icon: img_logo
    label: 'Портал'
  staff:
    href: 'http://staff'
    icon: img_phonebook
    label: 'Справочник сотрудников'


class Toolbar extends React.Component
#  @propTypes =
#    current_tool: PropTypes.string

  render: ->
    current = @props.current_tool

    div { className: 'toolbar plug' },
      for key, button of buttons
        toolbar_button { key: key, href: button.href, icon: button.icon, label: button.label, current: current == key }


export default Toolbar
