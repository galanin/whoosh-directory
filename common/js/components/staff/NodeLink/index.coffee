import React from 'react'
import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import classNames from 'classnames'

import CommonAvatar from '@components/staff/CommonAvatar'

import { goToNodeInStructure } from '@actions/nodes'
import { setHighlightedUnitId } from '@actions/current'
import { popNodeInfo, popStructure } from '@actions/layout'

div = React.createFactory('div')
img = React.createFactory('img')
avatar = React.createFactory(CommonAvatar)


mapStateToProps = (state, ownProps) ->
  node = state.nodes.data[ownProps.node_id]
  employment = state.employments[node?.employment_id]

  node: node
  tree_node: state.nodes.tree[ownProps.node_id]
  employment: employment
  person: state.people[employment?.person_id]
  unit: state.units[node?.unit_id]


mapDispatchToProps = (dispatch, ownProps) ->
  click: ->
    dispatch(goToNodeInStructure(@node.id))
    dispatch(popNodeInfo())
    dispatch(popStructure())


class NodeLink extends React.Component

  @propTypes =
    node_id: PropTypes.integer


  onUnitClick: ->
    @props.click()


  render: ->
    class_names =
      'node-link' : true
    class_names[@props.className] = true

    div { className: classNames(class_names), onClick: @onUnitClick.bind(this) },
      if @props.unit?
        [
          if @props.unit.short_title?
            div { className: 'node-link__unit-short-title', key: 'short' },
              @props.unit.short_title

          if @props.unit.long_title?
            div { className: 'node-link__unit-long-title', key: 'long' },
              @props.unit.long_title
        ]

      else if @props.employment?

        photo = @props.person?.photo

        div { className: 'node-link__employee-link' },
          div { className: 'node-link__employee-photo' },
            if photo?.thumb30?.url?
              img { src: process.env.PHOTO_BASE_URL + photo.thumb30.url, className: 'node-link__employee-thumb30' }
            else
              avatar { className: 'node-link__avatar', gender: @props.person?.gender, post_code: @props.employment.post_code }

          div { className: 'node-link__employment-post-title' },
            @props.employment.post_title


export default connect(mapStateToProps, mapDispatchToProps)(NodeLink)
