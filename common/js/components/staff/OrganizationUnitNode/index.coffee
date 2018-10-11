import React from 'react'
import PropTypes from 'prop-types'
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import classNames from 'classnames'
import SvgIcon from '@components/common/SvgIcon'

import { collapseUnit, saveCollapsedUnit, expandUnit, saveExpandedUnit } from '@actions/expand_units'
import { setCurrentUnitId } from '@actions/current_unit'
import { resetExpandedSubUnits } from '@actions/expand_sub_units'
import { loadUnitExtra } from '@actions/unit_extras'

div = React.createFactory('div')
svg = React.createFactory(SvgIcon)

import Minus from './icons/minus-square.svg'
import Plus from './icons/plus-square.svg'


mapStateToProps = (state, ownProps) ->
  unit_data: state.units[ownProps.unit_id]
  is_expanded: state.expanded_units[ownProps.unit_id]?
  current_unit_id: state.current_unit_id


mapDispatchToProps = (dispatch, ownProps) ->
  expand: ->
    dispatch(expandUnit(ownProps.unit_id))
    dispatch(saveExpandedUnit(ownProps.unit_id))
  collapse: ->
    dispatch(collapseUnit(ownProps.unit_id))
    dispatch(saveCollapsedUnit(ownProps.unit_id))
  setCurrentUnit: ->
    dispatch(setCurrentUnitId(ownProps.unit_id))
    dispatch(loadUnitExtra(ownProps.unit_id))
    dispatch(resetExpandedSubUnits())


class OrganizationUnitNode extends React.Component

  hasChildren: ->
    +@props.unit_data.child_ids?.length > 0


  onExpandCollapseClick: ->
    if @hasChildren()
      if @props.is_expanded
        @props.collapse()
      else
        @props.expand()


  onUnitClick: ->
    @props.setCurrentUnit()


  render: ->
    return @props.unit_id unless @props.unit_data?

    has_children = @hasChildren()

    node_class_name = classNames
      'organization-unit-node': true
      'organization-unit-node_expanded': @props.is_expanded
      'organization-unit-node_collapsed': !@props.is_expanded
      'organization-unit-node_has_children': has_children
      'organization-unit-node_has_no_children': !has_children

    title_class_name = classNames
      'organization-unit-node__title': true
      'organization-unit-node__title_current': @props.unit_id == @props.current_unit_id

    div { className: node_class_name },
      if has_children
        div { className: 'organization-unit-node__button', onClick: @onExpandCollapseClick.bind(this) },
          svg { className: 'organization-unit-node__button-open', svg: Plus }
          svg { className: 'organization-unit-node__button-close', svg: Minus }
      else
        div { className: 'organization-unit-node__button-stub' },

      div { className: 'organization-unit-node__content' },
        div { className: title_class_name, onClick: @onUnitClick.bind(this) },
          @props.unit_data.list_title
        if has_children
          div { className: 'organization-unit-node__children' },
            for child_id in @props.unit_data.child_ids
              organization_unit_node({ key: child_id, unit_id: child_id })


ConnectedOrganizationUnitNode = connect(mapStateToProps, mapDispatchToProps)(OrganizationUnitNode)
organization_unit_node = React.createFactory(ConnectedOrganizationUnitNode)

export default ConnectedOrganizationUnitNode
