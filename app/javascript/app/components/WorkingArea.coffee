require './WorkingArea.sass'

import React from 'react'
import PropTypes from 'prop-types'

div = React.createFactory('div')

import SearchPanel from './SearchPanel'
search_panel = React.createFactory(SearchPanel)

import OrganizationStructure from './OrganizationStructure'
organization_structure = React.createFactory(OrganizationStructure)


class WorkingArea extends React.Component
  render: ->
    div { className: 'working-area plug' },
      div { className: 'working-area__search-panel socket' },
        search_panel {}
      div { className: 'working-area__birthday-panel socket' }
      div { className: 'working-area__results-panel' },
        div { className: 'working-area__persons socket' }
        div { className: 'working-area__structure socket' },
          organization_structure {}


export default WorkingArea
