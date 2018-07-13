import React from 'react'
import PropTypes from 'prop-types'
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import classNames from 'classnames'
import InlineSVG from 'svg-inline-react'

import { collapseUnit, expandUnit } from '@actions/expand_units'

div = React.createFactory('div')
svg = React.createFactory(InlineSVG)

import Minus from './icons/minus-square.svg'
import Plus from './icons/plus-square.svg'


mapStateToProps = (state, ownProps) ->
  is_expanded = if state.expanded_units.toString() == '[object Set]'
      state.expanded_units.has(ownProps.unit_id)
    else
      state.expanded_units.indexOf(ownProps.unit_id) >= 0

  unit_data: state.organization_units[ownProps.unit_id]
  is_expanded: is_expanded

mapDispatchToProps = (dispatch, ownProps) ->
  expand: (unit_id) -> dispatch(expandUnit(unit_id))
  collapse: (unit_id) -> dispatch(collapseUnit(unit_id))


class OrganizationUnit extends React.Component

  hasChildren: ->
    @props.unit_data.child_ids?.length? > 0


  onClick: ->
    if @hasChildren()
      if @props.is_expanded
        @props.collapse(@props.unit_id)
      else
        @props.expand(@props.unit_id)


  render: ->
    return @props.unit_id unless @props.unit_data?

    has_children = @hasChildren()

    class_name = classNames
      'organization-unit': true
      'organization-unit_expanded': @props.is_expanded
      'organization-unit_collapsed': !@props.is_expanded
      'organization-unit_has_children': has_children
      'organization-unit_has_no_children': !has_children

    div { className: class_name },
      if has_children
        div { className: 'organization-unit__button', onClick: @onClick.bind(this) },
          svg { className: 'organization-unit__button-open', src: require('./icons/plus-square.svg') }
          svg { className: 'organization-unit__button-close', src: require('./icons/minus-square.svg') }
      else
        div { className: 'organization-unit__button-stub' },

      div { className: 'organization-unit__content' },
        div { className: 'organization-unit__title' },
          @props.unit_data.list_title
        if has_children
          div { className: 'organization-unit__children' },
            for child_id in @props.unit_data.child_ids
              organization_unit({ key: child_id, unit_id: child_id })


ConnectedOrganizationUnit = connect(mapStateToProps, mapDispatchToProps)(OrganizationUnit)
organization_unit = React.createFactory(ConnectedOrganizationUnit)

export default ConnectedOrganizationUnit
