import React from 'react'
import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import classNames from 'classnames'

import { goToNodeInStructure } from '@actions/nodes'
import { popNodeInfo, popStructure } from '@actions/layout'

div = React.createFactory('div')

mapStateToProps = (state, ownProps) ->
  unit: state.units[ownProps.unit_id]

mapDispatchToProps = (dispatch, ownProps) ->
  goToNode: (node_id) ->
    dispatch(goToNodeInStructure(node_id))
    dispatch(popNodeInfo())
    dispatch(popStructure())


class SearchResultUnit extends React.Component
  @propTypes =
    unit_id: PropTypes.integer

  onUnitClick: ->
    @props.goToNode(@props.unit.node_id)

  render: ->
    return '' unless @props.unit?

    class_names =
      'search-result-unit' : true
    class_names[@props.className] = true

    div { className: classNames(class_names), onClick: @onUnitClick.bind(this) },
      if @props.unit?.short_title?
        div { className: 'search-result-unit__short-title' },
          @props.unit.short_title
      if @props.unit?.long_title?
        div { className: 'search-result-unit__long-title' },
          @props.unit.long_title


export default connect(mapStateToProps, mapDispatchToProps)(SearchResultUnit)
