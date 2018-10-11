import React from 'react'
import PropTypes from 'prop-types'
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { isArray } from 'lodash';
import classNames from 'classnames'
import SvgIcon from '@components/common/SvgIcon'

import { expandSubUnit, collapseSubUnit } from '@actions/expand_sub_units'
import { loadUnitExtra } from '@actions/unit_extras'

div = React.createFactory('div')
span = React.createFactory('span')
svg = React.createFactory(SvgIcon)

import Employee from '@components/staff/Employee'
employee = React.createFactory(Employee)

import Triangle from '@icons/triangle.svg'


mapStateToProps = (state, ownProps) ->
  extra = state.unit_extras[ownProps.unit_id]
  unit_data:   state.units[ownProps.unit_id]
  unit_extra:  extra && extra.extra || {}
  loading:     extra && extra.loading
  loaded:      extra && extra.loaded
  is_expanded: state.expanded_sub_units[ownProps.unit_id]?

mapDispatchToProps = (dispatch, ownProps) ->
  expand: ->
    dispatch(expandSubUnit(ownProps.unit_id))
    dispatch(loadUnitExtra(ownProps.unit_id))
  collapse: ->
    dispatch(collapseSubUnit(ownProps.unit_id))


class OrganizationSubUnit extends React.Component

  onExpandCollapseClick: ->
    if @props.is_expanded
      @props.collapse()
    else
      @props.expand()


  render: ->
    return '' unless @props.unit_data

    sub_unit_class_names = classNames
      'sub-unit': true
      'sub-unit_expanded': @props.is_expanded
      'sub-unit_collapsed': !@props.is_expanded

    div { className: sub_unit_class_names },
      div { className: 'sub-unit__head', onClick: @onExpandCollapseClick.bind(this) },
        div { className: 'sub-unit__button' },
          svg { className: 'sub-unit__triangle', svg: Triangle }
        div { className: 'sub-unit__title' },
          @props.unit_data.list_title
      div { className: 'sub-unit__content' },

        if @props.is_expanded && isArray(@props.unit_extra?.employ_ids)
          div { className: 'sub-unit__employees' },
            for employment_id in @props.unit_extra.employ_ids
              employee { key: employment_id, employment_id: employment_id, hide: { unit: true } }

        if @props.is_expanded && isArray(@props.unit_data?.child_ids)
          div { className: 'sub-unit__sub-units' },
            for sub_unit_id in @props.unit_data.child_ids
              sub_unit { key: 'sub-unit-' + sub_unit_id, unit_id: sub_unit_id }


ConnectedOrganizationSubUnit = connect(mapStateToProps, mapDispatchToProps)(OrganizationSubUnit)
sub_unit = React.createFactory(ConnectedOrganizationSubUnit)

export default ConnectedOrganizationSubUnit
