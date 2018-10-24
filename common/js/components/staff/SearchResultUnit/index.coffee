import React from 'react'
import PropTypes from 'prop-types'
import { connect } from 'react-redux';

div = React.createFactory('div')

mapStateToProps = (state, ownProps) ->
  unit_id = ownProps.unit_id
  unit_data:  state.units[unit_id]

mapDispatchToProps = (dispatch) ->
  {}


class SearchResultUnit extends React.Component
  @propTypes =
    unit_id: PropTypes.integer

  render: ->
    div { className: 'search-result-unit' },
      @props.unit_data.list_title


export default connect(mapStateToProps, mapDispatchToProps)(SearchResultUnit)
