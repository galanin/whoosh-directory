import React from 'react'
import PropTypes from 'prop-types'

div = React.createFactory 'div'

class Header extends React.Component

  render: ->
    div { className: 'header plug' },
      div { className: 'header-title' },
        'Справочник сотрудников'

export default Header
