import React from 'react'
import PropTypes from 'prop-types'
import { fetchInitialState } from '@actions/initial_state';

div = React.createFactory('div')

import Header from '@components/common/Header'
header = React.createFactory(Header)

import WorkingArea from '@components/staff/WorkingArea'
working_area = React.createFactory(WorkingArea)


class TopLayout extends React.Component
  @fetchData: (state) ->
    initial_state = fetchInitialState()
    state.store.dispatch(initial_state)

  render: ->
    div { className: 'top-layout' },
      div { className: 'top-layout__header socket' },
        header {}
      div { className: 'top-layout__working-area socket' },
        working_area {}


export default TopLayout
