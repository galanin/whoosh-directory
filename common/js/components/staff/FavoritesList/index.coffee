import React from 'react'
import { connect } from 'react-redux'
import classNames from 'classnames'
import { isArray, isEmpty } from 'lodash'

import {
  FAVORITE_PEOPLE
  FAVORITE_UNITS
} from '@constants/favorites'
import { showFavoriteEmployments, showFavoriteUnits } from '@actions/favorites'

div = React.createFactory('div')
span = React.createFactory('span')

import EmployeeWithButtons from '@components/staff/EmployeeWithButtons'
employee = React.createFactory(EmployeeWithButtons)

import Contact from '@components/staff/Contact'
contact = React.createFactory(Contact)

import SearchResultUnit from '@components/staff/SearchResultUnit'
unit = React.createFactory(SearchResultUnit)


mapStateToProps = (state, ownProps) ->
  people: state.favorites.favorite_people
  units: state.favorites.favorite_units
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
      'favorites-list_employments' : @props.show == FAVORITE_PEOPLE
      'favorites-list_units' : @props.show == FAVORITE_UNITS
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
          when FAVORITE_PEOPLE
            if isArray(@props.people) and !isEmpty(@props.people)
              div { className: 'favorite-list__employments' },
                for favorite_people in @props.people
                  if favorite_people.employment_id?
                    employee { key: favorite_people.employment_id, employment_id: favorite_people.employment_id, className: 'list-item shadow' }
                  else if favorite_people.contact_id?
                    contact { key: favorite_people.contact_id, contact_id: favorite_people.contact_id, className: 'list-item shadow' }

          when FAVORITE_UNITS
            if isArray(@props.units) and !isEmpty(@props.units)
              div { className: 'favorite-list__units' },
                for favorite_unit in @props.units
                  unit { key: favorite_unit.unit_id, unit_id: favorite_unit.unit_id, className: 'list-item shadow' }


export default connect(mapStateToProps, mapDispatchToProps)(FavoritesList)
