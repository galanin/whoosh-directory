require './TopLayout.sass'

import React from 'react'
import PropTypes from 'prop-types'

div = React.createFactory('div')

import Toolbar from './Toolbar/Toolbar'
toolbar = React.createFactory(Toolbar)

import WorkingArea from './WorkingArea'
working_area = React.createFactory(WorkingArea)


class TopLayout extends React.Component
  render: ->
    div { className: 'top-layout' },
      div { className: 'top-layout__toolbar' },
        toolbar {}
      div { className: 'top-layout__working-area' },
        working_area {}


export default TopLayout
