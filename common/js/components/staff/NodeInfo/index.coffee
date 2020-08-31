import React from 'react'
import { connect } from 'react-redux'
import classNames from 'classnames'

div = React.createFactory('div')

import NodeEmploymentInfo from '@components/staff/NodeEmploymentInfo'
employee = React.createFactory(NodeEmploymentInfo)

import NodeUnitInfo from '@components/staff/NodeUnitInfo'
unit = React.createFactory(NodeUnitInfo)


mapStateToProps = (state) ->
  node_id = state.nodes.current_id
  node = state.nodes.data[node_id]
  child_node_ids = state.nodes.tree[node_id]?.c

  node: node
  child_ids: child_node_ids


mapDispatchToProps = (dispatch) ->
  {}


class NodeInfo extends React.Component

  render: ->
    return '' unless @props.node?

    class_names =
      'node-info' : true
      'socket' : true
    class_names[@props.className] = true

    div { className: classNames(class_names) },

      if @props.node.employment_id?
        employee { employment_id: @props.node.employment_id, className: 'plug' }
      else if @props.node.unit_id?
        unit { unit_id: @props.node.unit_id, className: 'plug' }


export default connect(mapStateToProps, mapDispatchToProps)(NodeInfo)
