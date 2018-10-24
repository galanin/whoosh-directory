import React from 'react'
import PropTypes from 'prop-types'
import { connect } from 'react-redux';

div = React.createFactory('div')

import SearchPanel from '@components/staff/SearchPanel'
search_panel = React.createFactory(SearchPanel)

import OrganizationUnitInfo from '@components/staff/OrganizationUnitInfo'
organization_unit_info = React.createFactory(OrganizationUnitInfo)

import OrganizationStructure from '@components/staff/OrganizationStructure'
organization_structure = React.createFactory(OrganizationStructure)

import EmployeeInfo from '@components/staff/EmployeeInfo'
employee_info = React.createFactory(EmployeeInfo)

import SearchResults from '@components/staff/SearchResults'
search_results = React.createFactory(SearchResults)


mapStateToProps = (state) ->
  pile: state.layout.pile

mapDispatchToProps = (dispatch) ->
  {}


class WorkingArea extends React.Component

  render: ->
    pile_hash = {}
    @props.pile.forEach (block, i) -> pile_hash[block] = i

    div { className: 'working-area plug' },
      div { className: 'working-area__search-panel socket' },
        search_panel {}
      div { className: 'working-area__birthday-panel socket' }
      div { className: 'working-area__results-panel' },
        div { className: "working-area__block working-area__unit-info socket block-index-#{pile_hash['unit-info']}" },
          organization_unit_info {}
        div { className: "working-area__block working-area__structure socket block-index-#{pile_hash['structure']}" },
          organization_structure {}
        div { className: "working-area__block working-area__employee-info socket block-index-#{pile_hash['employee-info']}" },
          employee_info {}
        div { className: "working-area__block working-area__results socket block-index-#{pile_hash['search-results']}" },
          search_results {}


export default connect(mapStateToProps, mapDispatchToProps)(WorkingArea)
