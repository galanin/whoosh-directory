import React from 'react'
import PropTypes from 'prop-types'

div = React.createFactory('div')

import SearchPanel from '@components/staff/SearchPanel'
search_panel = React.createFactory(SearchPanel)

import OrganizationUnitInfo from '@components/staff/OrganizationUnitInfo'
organization_unit_info = React.createFactory(OrganizationUnitInfo)

import OrganizationStructure from '@components/staff/OrganizationStructure'
organization_structure = React.createFactory(OrganizationStructure)


class WorkingArea extends React.Component
  render: ->
    div { className: 'working-area plug' },
      div { className: 'working-area__search-panel socket' },
        search_panel {}
      div { className: 'working-area__birthday-panel socket' }
      div { className: 'working-area__results-panel' },
        div { className: 'working-area__persons socket' },
          organization_unit_info {}
        div { className: 'working-area__structure socket' },
          organization_structure {}


export default WorkingArea
