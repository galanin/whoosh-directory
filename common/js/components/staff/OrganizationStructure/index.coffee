import React from 'react'
import PropTypes from 'prop-types'
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import * as UnitActions from '@actions/units';

div = React.createFactory('div')

import OrganizationUnit from '@components/staff/OrganizationUnit'
organization_unit = React.createFactory(OrganizationUnit)


mapStateToProps = (state) ->
  organization_units: state.organization_units

mapDispatchToProps = (dispatch) ->
  bindActionCreators(UnitActions, dispatch)


class OrganizationStructure extends React.Component
  @propTypes =
    organization_units: PropTypes.object

  render: ->
    roots = (unit.id for _, unit of @props.organization_units when unit.level == 0)
    roots.sort (a, b) ->
      if a.path < b.path
        -1
      else if a.path > b.path
        1
      else
        0

    div { className: 'organization-structure plug' },
      for root_id in roots
        organization_unit { key: root_id, unit_id: root_id }


export default connect(mapStateToProps, mapDispatchToProps)(OrganizationStructure)
