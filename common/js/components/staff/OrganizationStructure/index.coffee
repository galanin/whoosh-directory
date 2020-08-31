import React from 'react'
import PropTypes from 'prop-types'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import * as UnitActions from '@actions/units'
import { isEmpty } from 'lodash'

div = React.createFactory('div')

import Node from '@components/staff/Node'
node = React.createFactory(Node)


mapStateToProps = (state) ->
  root_ids: state.nodes.root_ids

mapDispatchToProps = (dispatch) ->
  bindActionCreators(UnitActions, dispatch)


class OrganizationStructure extends React.Component

  @propTypes =
    root_ids: PropTypes.array


  render: ->
    div { className: 'organization-structure-scroller soft-shadow plug', id: 'organization-structure-scroller' },
      div { className: 'organization-structure' },
        for root_id in @props.root_ids
          node { key: root_id, node_id: root_id }


export default connect(mapStateToProps, mapDispatchToProps)(OrganizationStructure)
