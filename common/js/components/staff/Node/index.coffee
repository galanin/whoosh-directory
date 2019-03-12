import React from 'react'
import { connect } from 'react-redux'
import classNames from 'classnames'
import SvgIcon from '@components/common/SvgIcon'
import { Element as ScrollElement, scroller } from 'react-scroll'

import {
  collapseNode
  saveCollapsedNode
  expandNode
  saveExpandedNode
  setCurrentNodeId
  scrolledToNode
} from '@actions/nodes'

import { popNodeInfo } from '@actions/layout'

div = React.createFactory('div')
svg = React.createFactory(SvgIcon)
scroll_element = React.createFactory(ScrollElement)

import MinusIcon from '@icons/minus-square.svg'
import PlusIcon from '@icons/plus-square.svg'


mapStateToProps = (state, ownProps) ->
  node: state.nodes.tree[ownProps.node_id]
  is_expanded: state.nodes.expanded[ownProps.node_id]?
  is_current: ownProps.node_id == state.nodes.current_id
  do_scroll: ownProps.node_id == state.nodes.scroll_to_id


mapDispatchToProps = (dispatch) ->
  expand: ->
    dispatch(expandNode(@node_id))
    dispatch(saveExpandedNode(@node_id))

  collapse: ->
    dispatch(collapseNode(@node_id))
    dispatch(saveCollapsedNode(@node_id))

  setCurrentNode: ->
    dispatch(setCurrentNodeId(@node_id))
    dispatch(popNodeInfo())

  scrolledToNode: ->
    dispatch(scrolledToNode(@node_id))


class Node extends React.Component

  hasChildren: ->
    +@props.node.c?.length > 0


  componentDidUpdate: (prevProps) ->
    if @props.do_scroll
      scroller.scrollTo "node-#{@props.node_id}",
        offset:   -200
        duration:  600
        smooth:    true
        isDynamic: true
        containerId: 'organization-structure-scroller'
      @props.scrolledToNode()


  onExpandCollapseClick: ->
    if @hasChildren()
      if @props.is_expanded
        @props.collapse()
      else
        @props.expand()


  onNodeClick: ->
    @props.setCurrentNode()


  render: ->
    return '' unless @props.node?

    has_children = @hasChildren()

    node_class_name = classNames
      'node': true
      'node_expanded': @props.is_expanded
      'node_collapsed': !@props.is_expanded
      'node_has_children': has_children
      'node_has_no_children': !has_children

    title_class_name = classNames
      'node__title': true
      'node__title_current': @props.is_current
      'node__title_highlighted': @props.is_highlighted

    div { className: node_class_name },
      if has_children
        div { className: 'node__button', onClick: @onExpandCollapseClick.bind(this) },
          svg { className: 'node__button-open', svg: PlusIcon }
          svg { className: 'node__button-close', svg: MinusIcon }
      else
        div { className: 'node__button-stub' }

      div { className: 'node__content' },
        scroll_element { className: title_class_name, onClick: @onNodeClick.bind(this), name: "node-#{@props.node_id}" },
          @props.node.t
        if has_children
          div { className: 'node__children' },
            for child_id in @props.node.c
              node { key: child_id, node_id: child_id }


ConnectedNode = connect(mapStateToProps, mapDispatchToProps)(Node)
node = React.createFactory(ConnectedNode)

export default ConnectedNode
