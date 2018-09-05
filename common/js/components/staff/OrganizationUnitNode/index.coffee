import React from 'react'
import PropTypes from 'prop-types'
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import classNames from 'classnames'
import SvgIcon from '@components/common/SvgIcon'

import { collapseUnit, saveCollapsedUnit, expandUnit, saveExpandedUnit } from '@actions/expand_units'
import { loadUnitInfo } from '@actions/units'

div = React.createFactory('div')
svg = React.createFactory(SvgIcon)

import Minus from './icons/minus-square.svg'
import Plus from './icons/plus-square.svg'


mapStateToProps = (state, ownProps) ->
  unit_data: state.organization_units[ownProps.unit_id]
  is_expanded: state.expanded_units[ownProps.unit_id]?

mapDispatchToProps = (dispatch, ownProps) ->
  expand: ->
    dispatch(expandUnit(ownProps.unit_id))
    dispatch(saveExpandedUnit(ownProps.unit_id))
  collapse: ->
    dispatch(collapseUnit(ownProps.unit_id))
    dispatch(saveCollapsedUnit(ownProps.unit_id))
  loadEmployees: ->
    dispatch(loadUnitInfo(ownProps.unit_id))


class OrganizationUnitNode extends React.Component

  hasChildren: ->
    @props.unit_data.child_ids?.length? > 0


  onExpandCollapseClick: ->
    if @hasChildren()
      if @props.is_expanded
        @props.collapse()
      else
        @props.expand()


  onUnitClick: ->
    @props.loadEmployees()


  render: ->
    return @props.unit_id unless @props.unit_data?

    has_children = @hasChildren()

    class_name = classNames
      'organization-unit-node': true
      'organization-unit-node_expanded': @props.is_expanded
      'organization-unit-node_collapsed': !@props.is_expanded
      'organization-unit-node_has_children': has_children
      'organization-unit-node_has_no_children': !has_children

    div { className: class_name },
      if has_children
        div { className: 'organization-unit-node__button', onClick: @onExpandCollapseClick.bind(this) },
          svg { className: 'organization-unit-node__button-open', svg: Plus }
          svg { className: 'organization-unit-node__button-close', svg: Minus }
      else
        div { className: 'organization-unit-node__button-stub' },

      div { className: 'organization-unit-node__content' },
        div { className: 'organization-unit-node__title', onClick: @onUnitClick.bind(this) },
          @props.unit_data.list_title
        if has_children
          div { className: 'organization-unit-node__children' },
            for child_id in @props.unit_data.child_ids
              organization_unit({ key: child_id, unit_id: child_id })


ConnectedOrganizationUnit = connect(mapStateToProps, mapDispatchToProps)(OrganizationUnitNode)
organization_unit = React.createFactory(ConnectedOrganizationUnit)

export default ConnectedOrganizationUnit
