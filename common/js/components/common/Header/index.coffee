import React from 'react'
import PropTypes from 'prop-types'

div = React.createFactory 'div'
a = React.createFactory 'a'

class Header extends React.Component

  onClick: (event) ->
    event.preventDefault()


  render: ->
    div { className: 'header plug' },
      a { className: 'header-title', href: '/', onClick: @onClick.bind(this) },
        'Справочник сотрудников'

export default Header
