import React from 'react'
import { connect } from 'react-redux'
import classNames from 'classnames'
import { isArray, isEmpty } from 'lodash'

import { showFavoriteEmployments, showFavoriteUnits } from '@actions/favorites'

div = React.createFactory('div')
span = React.createFactory('span')

import EmployeeWithButtons from '@components/staff/EmployeeWithButtons'
employee = React.createFactory(EmployeeWithButtons)

import SearchResultUnit from '@components/staff/SearchResultUnit'
unit = React.createFactory(SearchResultUnit)


mapStateToProps = (state, ownProps) ->
  employment_ids: state.favorites.employment_ids
  unit_ids: state.favorites.unit_ids
  show: state.favorites.show


mapDispatchToProps = (dispatch) ->
  showEmployments: ->
    dispatch(showFavoriteEmployments())
  showUnits: ->
    dispatch(showFavoriteUnits())


class FavoritesList extends React.Component

  showEmployments: ->
    @props.showEmployments()


  showUnits: ->
    @props.showUnits()


  render: ->
    class_names =
      'favorites-list' : true
      'favorites-list__scroller' : true
      'favorites-list_employments' : @props.show == 'employments'
      'favorites-list_units' : @props.show == 'units'
    class_names[@props.className] = true

    div { className: classNames(class_names) },
      div { className: 'favorites-list-container' },
        div { className: 'favorites-list__header' },
          span { className: 'favorites-list__title' },
            'Избранное'
          span { className: 'favorites-list__header-buttons' },
            span { className: 'favorites-list__header-button favorites-list__header-button-employments', onClick: @showEmployments.bind(this) },
              'Сотрудники'
            span { className: 'favorites-list__header-button favorites-list__header-button-units', onClick: @showUnits.bind(this) },
              'Оргструктура'

        switch @props.show
          when 'employments'
            if isArray(@props.employment_ids) and !isEmpty(@props.employment_ids)
              div { className: 'favorite-list__employments' },
                for employment_id in @props.employment_ids
                  employee { key: employment_id, employment_id: employment_id, className: 'list-item shadow' }

          when 'units'
            if isArray(@props.unit_ids) and !isEmpty(@props.unit_ids)
              div { className: 'favorite-list__units' },
                for unit_id in @props.unit_ids
                  unit { key: unit_id, unit_id: unit_id, className: 'list-item shadow' }


export default connect(mapStateToProps, mapDispatchToProps)(FavoritesList)
