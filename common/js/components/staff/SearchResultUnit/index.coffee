import React from 'react'
import PropTypes from 'prop-types'
import { connect } from 'react-redux'

import { highlightUnit, goToUnitInStructure } from '@actions/units'
import { isThreeColumn, isFourColumn } from '@lib/layout'
import { setHighlightedUnitId } from '@actions/current'

div = React.createFactory('div')

mapStateToProps = (state, ownProps) ->
  unit_id = ownProps.unit_id
  unit_data:  state.units[unit_id]

mapDispatchToProps = (dispatch, ownProps) ->
  click: ->
    if isThreeColumn() or isFourColumn()
      dispatch(setHighlightedUnitId(null))
      dispatch(goToUnitInStructure(ownProps.unit_id))
    else
      dispatch(highlightUnit(ownProps.unit_id))


class SearchResultUnit extends React.Component
  @propTypes =
    unit_id: PropTypes.integer

  onUnitClick: ->
    @props.click()

  render: ->
    div { className: 'search-result-unit', onClick: @onUnitClick.bind(this) },
      @props.unit_data.list_title


export default connect(mapStateToProps, mapDispatchToProps)(SearchResultUnit)
