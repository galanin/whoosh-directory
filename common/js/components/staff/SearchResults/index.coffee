import React from 'react'
import { connect } from 'react-redux'
import { isArray } from 'lodash'

div = React.createFactory('div')

import SearchResultUnit from '@components/staff/SearchResultUnit'
result_unit = React.createFactory(SearchResultUnit)

import Employee from '@components/staff/Employee'
employee = React.createFactory(Employee)

import Contact from '@components/staff/Contact'
contact = React.createFactory(Contact)


mapStateToProps = (state, ownProps) ->
  results: state.search.results
  query: state.search.current_machine_query

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
                result_unit key: result.unit_id, unit_id: result.unit_id, className: 'list-item shadow'
              else if result.contact_id?
                contact key: result.contact_id, contact_id: result.contact_id, className: 'list-item shadow'
              else if result.person_id?
                employee key: result.person_id, employment_id: result.employ_ids[0], className: 'list-item shadow'

        else
          div { className: 'search-results__no-results' },
            if !@props.query or @props.query == ''
              'Введите ваш запрос в поисковую строку выше'
            else
              'Ничего не найдено'


export default connect(mapStateToProps, mapDispatchToProps)(SearchResults)
