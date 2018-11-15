import React from 'react'
import PropTypes from 'prop-types'
import { connect } from 'react-redux'

import { highlightUnit, goToUnitInStructure } from '@actions/units'
import { setHighlightedUnitId } from '@actions/current'
import { resetExpandedSubUnits } from '@actions/expand_sub_units'
import { loadUnitExtra } from '@actions/unit_extras'
import { popUnitInfo } from '@actions/layout'

div = React.createFactory('div')

mapStateToProps = (state, ownProps) ->
  unit_id = ownProps.unit_id
  unit_data:  state.units[unit_id]

mapDispatchToProps = (dispatch, ownProps) ->
  click: ->
    dispatch(goToUnitInStructure(ownProps.unit_id))
    dispatch(loadUnitExtra(ownProps.unit_id))
    dispatch(resetExpandedSubUnits())
    dispatch(popUnitInfo())


class SearchResultUnit extends React.Component
  @propTypes =
    unit_id: PropTypes.integer

  onUnitClick: ->
    @props.click()

  render: ->
    div { className: 'search-result-unit', onClick: @onUnitClick.bind(this) },
      @props.unit_data.list_title


export default connect(mapStateToProps, mapDispatchToProps)(SearchResultUnit)
