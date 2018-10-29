import React from 'react'
import { connect } from 'react-redux';
import { isArray } from 'lodash';

div = React.createFactory('div')

import SearchResultUnit from '@components/staff/SearchResultUnit'
result_unit = React.createFactory(SearchResultUnit)

import Employee from '@components/staff/Employee'
employee = React.createFactory(Employee)


mapStateToProps = (state, ownProps) ->
  results: state.search.results

mapDispatchToProps = (dispatch) ->
  {}


class SearchResults extends React.Component
  render: ->
    div { className: 'search-results__scroller plug' },
      div { className: 'search-results' },
        div { className: 'search-results__title' },
          'Результаты поиска'

        if isArray(@props.results) and @props.results.length > 0
          div { className: 'search-results__results' },
            for result in @props.results
              if result.unit_id?
                result_unit({ key: result.unit_id, unit_id: result.unit_id })
              else if result.person_id?
                employee({ key: result.person_id, employment_id: result.employ_ids[0] })

        else
          div { className: 'search-results__no-results' },
            'Безрезультатно'




export default connect(mapStateToProps, mapDispatchToProps)(SearchResults)
