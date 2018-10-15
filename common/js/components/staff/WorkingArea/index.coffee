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
        div { className: "working-area__unit-info socket block-index-#{pile_hash['unit-info']}" },
          organization_unit_info {}
        div { className: "working-area__structure socket block-index-#{pile_hash['structure']}" },
          organization_structure {}


export default connect(mapStateToProps, mapDispatchToProps)(WorkingArea)
