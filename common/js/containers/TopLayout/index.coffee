import React from 'react'
import PropTypes from 'prop-types'
import { fetchInitialState } from '@actions/initial_state';

div = React.createFactory('div')

import Toolbar from '@components/common/Toolbar'
toolbar = React.createFactory(Toolbar)

import WorkingArea from '@components/staff/WorkingArea'
working_area = React.createFactory(WorkingArea)


class TopLayout extends React.Component
  @fetchData: (state) ->
    initial_state = fetchInitialState()
    state.store.dispatch(initial_state)

  render: ->
    div { className: 'top-layout' },
      div { className: 'top-layout__toolbar socket' },
        toolbar {}
      div { className: 'top-layout__working-area socket' },
        working_area {}


export default TopLayout
