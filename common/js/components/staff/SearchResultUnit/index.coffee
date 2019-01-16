import React from 'react'
import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import classNames from 'classnames'

import { highlightUnit, goToUnitInStructure } from '@actions/units'
import { setHighlightedUnitId } from '@actions/current'
import { popUnitInfo } from '@actions/layout'

div = React.createFactory('div')

mapStateToProps = (state, ownProps) ->
  unit_id = ownProps.unit_id
  unit_data:   state.units[unit_id]
  unit_titles: state.unit_titles[unit_id] || {}

mapDispatchToProps = (dispatch, ownProps) ->
  click: ->
    dispatch(goToUnitInStructure(ownProps.unit_id))
    dispatch(popUnitInfo())


class SearchResultUnit extends React.Component
  @propTypes =
    unit_id: PropTypes.integer

  onUnitClick: ->
    @props.click()

  render: ->
    class_names =
      'search-result-unit' : true
    class_names[@props.className] = true

    div { className: classNames(class_names), onClick: @onUnitClick.bind(this) },
      if @props.unit_titles.short_title
        div { className: 'search-result-unit__short-title' },
          @props.unit_titles.short_title
      if @props.unit_titles.long_title
        div { className: 'search-result-unit__long-title' },
          @props.unit_titles.long_title


export default connect(mapStateToProps, mapDispatchToProps)(SearchResultUnit)
