import React from 'react'
import PropTypes from 'prop-types'
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { isArray } from 'lodash';
#import * as UnitActions from '@actions/organization_unit';

div = React.createFactory('div')

import Employee from '@components/staff/Employee'
employee = React.createFactory(Employee)


mapStateToProps = (state) ->
  unit_id = state.current_unit_id
  extra = state.unit_extras[unit_id]
  unit_id:    unit_id
  unit_extra: extra && extra.extra || {}
  loading:    extra && extra.loading
  loaded:     extra && extra.loaded

mapDispatchToProps = (dispatch) ->
  {}
#  bindActionCreators(UnitActions, dispatch)


class OrganizationUnitInfo extends React.Component
  @propTypes =
    unit_id: PropTypes.integer

  render: ->
    if @props.unit_id?
      div { className: 'organization-unit-scroller plug' },
        div { className: 'organization-unit' },
          if @props.unit_extra.short_title?
            div { className: 'organization-unit__short-title' },
              @props.unit_extra.short_title
          if @props.unit_extra.long_title? and @props.unit_extra.long_title != @props.unit_extra.short_title
            div { className: 'organization-unit__long-title' },
              @props.unit_extra.long_title

          if isArray(@props.unit_extra.employment_ids)
            div { className: 'organization-unit__employees' },
              for employment_id in @props.unit_extra.employment_ids
                employee { key: employment_id, employment_id: employment_id, hide: { unit: true } }
    else
      '...'


export default connect(mapStateToProps, mapDispatchToProps)(OrganizationUnitInfo)
