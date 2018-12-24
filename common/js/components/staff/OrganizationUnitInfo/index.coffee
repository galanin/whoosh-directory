import React from 'react'
import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import { isArray } from 'lodash'

div = React.createFactory('div')

import Employee from '@components/staff/Employee'
employee = React.createFactory(Employee)

import OrganizationSubUnit from '@components/staff/OrganizationSubUnit'
sub_unit = React.createFactory(OrganizationSubUnit)

import Contact from '@components/staff/Contact'
contact = React.createFactory(Contact)


mapStateToProps = (state) ->
  unit_id = state.current.unit_id
  extra = state.unit_extras[unit_id]
  unit_id:     unit_id
  unit_data:   state.units[unit_id]
  unit_titles: state.unit_titles[unit_id] || {}
  loading:     extra?.loading
  loaded:      extra?.loaded

mapDispatchToProps = (dispatch) ->
  {}


class OrganizationUnitInfo extends React.Component
  @propTypes =
    unit_id: PropTypes.integer

  render: ->
    if @props.unit_id?
      div { className: 'organization-unit-scroller plug' },
        div { className: 'organization-unit' },
          if @props.unit_titles.short_title?
            div { className: 'organization-unit__short-title' },
              @props.unit_titles.short_title
          if @props.unit_titles.long_title? and @props.unit_titles.long_title != @props.unit_titles.short_title
            div { className: 'organization-unit__long-title' },
              @props.unit_titles.long_title

          if isArray(@props.unit_data.employ_ids)
            div { className: 'organization-unit__employees' },
              for employment_id in @props.unit_data.employ_ids
                employee key: employment_id, employment_id: employment_id, hide: { unit: true }, className: 'list-item shadow'

          if isArray(@props.unit_data.contact_ids)
            div { className: 'organization-unit__contacts' },
              for contact_id in @props.unit_data.contact_ids
                contact { key: contact_id, contact_id: contact_id, hide: { unit: true } }

          if isArray(@props.unit_data.child_ids)
            div { className: 'organization-unit__sub-units' },
              for sub_unit_id in @props.unit_data.child_ids
                sub_unit { key: 'sub-unit-' + sub_unit_id, unit_id: sub_unit_id }

    else
      '...'


export default connect(mapStateToProps, mapDispatchToProps)(OrganizationUnitInfo)
