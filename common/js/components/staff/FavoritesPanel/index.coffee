import React from 'react'
import { connect } from 'react-redux'
import classNames from 'classnames'

import { popFavorites } from '@actions/layout'

import SvgIcon from '@components/common/SvgIcon'
import StarIcon from '@icons/star.svg'

div = React.createFactory('div')
span = React.createFactory('span')
svg = React.createFactory(SvgIcon)


mapStateToProps = (state, ownProps) ->
  employee_counter: state.favorites.favorite_people.length
  unit_counter: state.favorites.favorite_units.length


mapDispatchToProps = (dispatch, ownProps) ->
  clickFavorites: ->
    dispatch(popFavorites())


class FavoritesPanel extends React.Component

  onClick: ->
    @props.clickFavorites()


  render: ->
    class_names =
      'favorites-panel' : true
      'favorites-panel_counter-highlighted' : @props.counter > 0
    class_names[@props.className] = true

    div { className: classNames(class_names), onClick: @onClick.bind(this) },
      svg { className: 'medium-icon favorites-panel__icon', svg: StarIcon }
      span { className: 'favorites-panel__title' },
        'Избранное'
      span { className: 'favorites-panel__counter' },
        @props.employee_counter
      span { className: 'favorites-panel__counter' },
        @props.unit_counter


export default connect(mapStateToProps, mapDispatchToProps)(FavoritesPanel)
