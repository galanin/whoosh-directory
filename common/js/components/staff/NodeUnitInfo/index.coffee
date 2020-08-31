import React from 'react'
import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import classNames from 'classnames'
import { isArray, isEmpty, compact } from 'lodash'

import { addFavoriteUnit, removeFavoriteUnit } from '@actions/favorites'

import SvgIcon from '@components/common/SvgIcon'
import SomeoneWithButtons from '@components/staff/SomeoneWithButtons'
import NodeLink from '@components/staff/NodeLink'
import StarIcon from '@icons/star.svg'

div = React.createFactory('div')
svg = React.createFactory(SvgIcon)

someone = React.createFactory(SomeoneWithButtons)
node_link = React.createFactory(NodeLink)


mapStateToProps = (state, ownProps) ->
  unit = state.units[ownProps.unit_id]
  node = state.nodes.data[unit?.node_id]
  tree_node = state.nodes.tree[unit?.node_id]
  employments = compact(state.employments[e_id] for e_id in (node?.employ_ids || []))
  child_nodes = compact(state.nodes.data[node_id] for node_id in (tree_node?.c || []))

  unit:        unit
  node:        node
  tree_node:   tree_node
  is_favorite: state.favorites.unit_index[ownProps.unit_id]
  employments: employments
  child_nodes: child_nodes


mapDispatchToProps = (dispatch) ->
  favorite: (unit_id) ->
    dispatch(addFavoriteUnit(unit_id))

  unfavorite: (unit_id) ->
    dispatch(removeFavoriteUnit(unit_id))


class NodeUnitInfo extends React.Component
  @propTypes =
    unit_id: PropTypes.integer


  onClickFavorite: ->
    if @props.is_favorite
      @props.unfavorite(@props.unit_id)
    else
      @props.favorite(@props.unit_id)


  render: ->
    return '' unless @props.unit?

    class_names =
      'unit' : true
      'unit__scroller' : true
      'unit_is-favorite' : @props.is_favorite
    class_names[@props.className] = true

    child_class_name = 'list-item shadow'
    if @props.unit.head_id?
      child_class_name += ' hierarchy-child'

    div { className: classNames(class_names) },

      if @props.unit.short_title?
        div { className: 'unit__short-title' },
          @props.unit.short_title

          svg { className: 'medium-icon unit__favorite', svg: StarIcon, onClick: @onClickFavorite.bind(this) }

      if @props.unit.long_title?
        div { className: 'unit__long-title' },
          @props.unit.long_title

          unless @props.unit.short_title?
            svg { className: 'medium-icon unit__favorite', svg: StarIcon, onClick: @onClickFavorite.bind(this) }

      if @props.unit.head_id?
        someone key: @props.unit.head_id, employment_id: @props.unit.head_id, hide: { unit: true }, className: 'list-item shadow hierarchy-root'

      if @props.node? and @props.tree_node?
        [
          for employment in @props.employments
            if employment.id != @props.unit.head_id
              someone key: employment.id, employment_id: employment.id, hide: { unit: true }, className: child_class_name

          if isArray(@props.node?.contact_ids)
            for contact_id in @props.node.contact_ids
              someone key: contact_id, contact_id: contact_id, hide: { unit: true }, className: child_class_name

          for child_node in @props.child_nodes
            node_link key: child_node.id, node_id: child_node.id, className: child_class_name
        ]


export default connect(mapStateToProps, mapDispatchToProps)(NodeUnitInfo)
