require './App.sass'

import React from 'react'
import PropTypes from 'prop-types'
import { Provider } from 'react-redux'
import { ConnectedRouter } from 'react-router-redux';
import { Route } from 'react-router'

import history from './utils/history'
import store from './utils/store'
import { setUnits } from './actions/units'
import { setExpandedUnits } from './actions/expand_units'

import TopLayout from './components/TopLayout'


provider = React.createFactory(Provider)
connected_router = React.createFactory(ConnectedRouter)
route = React.createFactory(Route)


class App extends React.Component
  @propTypes =
    organization_units: PropTypes.object
  @contextTypes =
    store: PropTypes.object

  componentWillMount: ->
    store.dispatch setUnits(this.props.organization_units)
    store.dispatch setExpandedUnits(this.props.expanded_units)

  render: ->
    provider { store: store },
      connected_router { history: history },
        route { component: TopLayout }


export default App
