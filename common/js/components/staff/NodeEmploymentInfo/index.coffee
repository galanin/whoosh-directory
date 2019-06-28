import React from 'react'
import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import classNames from 'classnames'
import { isArray } from 'lodash'

import { addFavoriteEmployment, removeFavoriteEmployment } from '@actions/favorites'

import SvgIcon from '@components/common/SvgIcon'
import EmployeeWithButtons from '@components/staff/EmployeeWithButtons'
import SomeoneWithButtons from '@components/staff/SomeoneWithButtons'
import NodeLink from '@components/staff/NodeLink'
import StarIcon from '@icons/star.svg'

div = React.createFactory('div')
svg = React.createFactory(SvgIcon)

employee = React.createFactory(EmployeeWithButtons)
someone = React.createFactory(SomeoneWithButtons)
node_link = React.createFactory(NodeLink)


mapStateToProps = (state, ownProps) ->
  employment = state.employments[ownProps.employment_id]
  tree_node = state.nodes.tree[employment?.node_id]
  node = state.nodes.data[employment?.node_id]

  employment:  employment
  node:        node
  tree_node:   tree_node
  employ_ids:  node?.employ_ids
  child_ids:   tree_node?.c
  is_favorite: state.favorites.employment_index[ownProps.employment_id]


mapDispatchToProps = (dispatch) ->
  favorite: (employment_id) ->
    dispatch(addFavoriteUnit(employment_id))

  unfavorite: (employment_id) ->
    dispatch(removeFavoriteEmployment(employment_id))


class NodeEmploymentInfo extends React.Component
  @propTypes =
    employment_id: PropTypes.integer


  onClickFavorite: ->
    if @props.is_favorite
      @props.unfavorite(@props.employment_id)
    else
      @props.favorite(@props.employment_id)


  render: ->
    return '' unless @props.employment?

    class_names =
      'node-employment' : true
      'node-employment__scroller' : true
      'node-employment_is-favorite' : @props.is_favorite
    class_names[@props.className] = true

    div { className: classNames(class_names) },

      if @props.employment.post_title?
        div { className: 'node-employment__post-title' },
          @props.employment.post_title

      div { className: 'hierarchy-root' },
        employee employment_id: @props.employment_id, hide: { unit: true, post: true }, className: 'list-item shadow'

      if @props.node?
        [
          if isArray(@props.employ_ids)
            for employment_id in @props.employ_ids
              div { className: 'hierarchy-child' },
                someone key: employment_id, employment_id: employment_id, className: 'list-item shadow'

          if isArray(@props.node?.contact_ids)
            for contact_id in @props.node.contact_ids
              div { className: 'hierarchy-child' },
                someone key: contact_id, contact_id: contact_id, hide: { unit: true }, className: 'list-item shadow'

          if isArray(@props.child_ids)
            for child_node_id in @props.child_ids
              div { className: 'hierarchy-child' },
                node_link key: 'child-node-' + child_node_id, node_id: child_node_id, className: 'list-item shadow'
        ]


export default connect(mapStateToProps, mapDispatchToProps)(NodeEmploymentInfo)
