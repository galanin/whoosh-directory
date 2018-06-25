require './OrganizationUnit.sass'

import React from 'react'
import PropTypes from 'prop-types'
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import classNames from 'classnames'

import { collapseUnit, expandUnit } from '../actions/expand_units'

div = React.createFactory('div')
svg = React.createFactory('svg')
path = React.createFactory('path')


mapStateToProps = (state, ownProps) ->
  unit_data: state.organization_units[ownProps.unit_id]
  is_expanded: state.expanded_units.has(ownProps.unit_id)

mapDispatchToProps = (dispatch, ownProps) ->
  expand: (unit_id) -> dispatch(expandUnit(unit_id))
  collapse: (unit_id) -> dispatch(collapseUnit(unit_id))


class OrganizationUnit extends React.Component

  onClick: ->
    if @props.unit_data.child_ids.length > 0
      if @props.is_expanded
        @props.collapse(@props.unit_id)
      else
        @props.expand(@props.unit_id)

  render: ->
    return @props.unit_id unless @props.unit_data?

    has_children = @props.unit_data.child_ids.length > 0

    class_name = classNames
      'organization-unit': true
      'organization-unit_expanded': @props.is_expanded
      'organization-unit_collapsed': !@props.is_expanded
      'organization-unit_has_children': has_children
      'organization-unit_has_no_children': !has_children

    div { className: class_name },
      if has_children
        div { className: 'organization-unit__button', onClick: @onClick.bind(this) },
          svg { className: 'organization-unit__button-open', viewBox: '0 0 32 32' },
            path { className: 'organization-unit__button-bg', d: 'M2 2h28v28H2z' }
            path { className: 'organization-unit__button-border', d: 'M4 4v24h24V4zm1 1h22v22H5z' }
            path { className: 'organization-unit__button-sign', d: 'M15 8v7H8v2h7v7h2v-7h7v-2h-7V8h-2z' }
          svg { className: 'organization-unit__button-close', viewBox: '0 0 32 32' },
            path { className: 'organization-unit__button-bg', d: 'M2 2h28v28H2z' }
            path { className: 'organization-unit__button-border', d: 'M4 4v24h24V4zm1 1h22v22H5z' }
            path { className: 'organization-unit__button-sign', d: 'M24 15v2H8v-2z' }
      else
        div { className: 'organization-unit__button-stub' },

      div { className: 'organization-unit__content' },
        div { className: 'organization-unit__title' },
          @props.unit_data.list_title
        if @props.unit_data.child_ids.length > 0
          div { className: 'organization-unit__children' },
            for child_id in @props.unit_data.child_ids
              organization_unit({ key: child_id, unit_id: child_id })


ConnectedOrganizationUnit = connect(mapStateToProps, mapDispatchToProps)(OrganizationUnit)
organization_unit = React.createFactory(ConnectedOrganizationUnit)

export default ConnectedOrganizationUnit
