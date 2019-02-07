import React from 'react'
import { connect } from 'react-redux'
import classNames from 'classnames'
import { includes } from 'lodash'

import SvgIcon from '@components/common/SvgIcon'

import { addToCall, checkToCall } from '@actions/to_call'
import { addFavoriteEmployment, removeFavoriteEmployment } from '@actions/favorites'

div = React.createFactory('div')
span = React.createFactory('span')
svg = React.createFactory(SvgIcon)

import ToCallIcon from '@icons/call.svg'
import StarIcon from '@icons/star.svg'


mapStateToProps = (state, ownProps) ->
  employment  : state.employments[ownProps.employment_id]
  is_to_call  : state.to_call?.unchecked_employment_index?[ownProps.employment_id]
  is_favorite : includes(state.favorites.employment_ids, ownProps.employment_id)


mapDispatchToProps = (dispatch, ownProps) ->
  addToCall: ->
    dispatch(addToCall(ownProps.employment_id))

  checkToCall: ->
    dispatch(checkToCall(ownProps.employment_id))

  favorite: ->
    dispatch(addFavoriteEmployment(ownProps.employment_id))

  unfavorite: ->
    dispatch(removeFavoriteEmployment(ownProps.employment_id))


class EmployeeButtons extends React.Component

  onAddToCall: ->
    if @props.is_to_call
      @props.checkToCall()
    else
      @props.addToCall()


  onFavorite: ->
    if @props.is_favorite
      @props.unfavorite()
    else
      @props.favorite()


  render: ->
    class_names =
      'employee-buttons' : true
      'employee-buttons_is-to-call-scheduled' : @props.is_to_call
      'employee-buttons_is-favorite' : @props.is_favorite
    class_names[@props.className] = true

    div { className: classNames(class_names) },
      div { className: 'employee-buttons__button employee-buttons__to-call', onClick: @onAddToCall.bind(this) },
        svg { className: 'employee-buttons__icon', svg: ToCallIcon }
        span { className: 'employee-buttons__label' },
          if @props.is_to_call
            'Запланирован звонок'
          else
            'Запланировать звонок'

      div { className: 'employee-buttons__button employee-buttons__favorite', onClick: @onFavorite.bind(this) },
        svg { className: 'employee-buttons__icon', svg: StarIcon }
        span { className: 'employee-buttons__label' },
          if @props.is_favorite
            'В избранном'
          else
            'Добавить в избранное'


export default connect(mapStateToProps, mapDispatchToProps)(EmployeeButtons)
