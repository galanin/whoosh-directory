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
  unit_info: state.organization_unit.unit_info
  loading:   state.organization_unit.loading
  loaded:    state.organization_unit.loaded

mapDispatchToProps = (dispatch) ->
  {}
#  bindActionCreators(UnitActions, dispatch)


class OrganizationUnitInfo extends React.Component
  @propTypes =
    unit_info: PropTypes.object
    loading: PropTypes.boolean
    loaded: PropTypes.boolean

  render: ->
    if @props.unit_info?
      div { className: 'organization-unit-scroller plug' },
        div { className: 'organization-unit' },
          if @props.unit_info.short_title?
            div { className: 'organization-unit__short-title' },
              @props.unit_info.short_title
          if @props.unit_info.long_title? and @props.unit_info.long_title != @props.unit_info.short_title
            div { className: 'organization-unit__long-title' },
              @props.unit_info.long_title

          if isArray(@props.unit_info.employment_ids)
            div { className: 'organization-unit__employees' },
              for employment_id in @props.unit_info.employment_ids
                employee { key: employment_id, employment_id: employment_id, hide: { unit: true } }
    else
      '...'


export default connect(mapStateToProps, mapDispatchToProps)(OrganizationUnitInfo)
