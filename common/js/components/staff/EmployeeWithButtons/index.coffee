import React from 'react'
import { connect } from 'react-redux'
import classNames from 'classnames'
import { includes } from 'lodash'

import SvgIcon from '@components/common/SvgIcon'

import { addToCall, checkToCall } from '@actions/to_call'
import { addFavoriteEmployment, removeFavoriteEmployment } from '@actions/favorites'


div = React.createFactory('div')
svg = React.createFactory(SvgIcon)

import Employee from '@components/staff/Employee'
employee = React.createFactory(Employee)

import ToCallIcon from '@icons/call.svg'
import StarIcon from '@icons/star.svg'


mapStateToProps = (state, ownProps) ->
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


class EmployeeWithButtons extends React.Component

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
      'employee-with-buttons' : true
      'employee-buttons-container' : true
      'employee-with-buttons_is-to-call-scheduled' : @props.is_to_call
      'employee-with-buttons_is-favorite' : @props.is_favorite
    class_names[@props.className] = true

    div { className: classNames(class_names) },
      employee employment_id: @props.employment_id, hide: @props.hide, className: 'employee-with-buttons__employee'
      div { className: 'employee-with-buttons__buttons employee-buttons-container__buttons' },
        div { className: 'employee-with-buttons__button employee-with-buttons__to-call employee-buttons-container__button', onClick: @onAddToCall.bind(this) },
          svg { className: 'employee-with-buttons__icon', svg: ToCallIcon }
        div { className: 'employee-with-buttons__button employee-with-buttons__favorite employee-buttons-container__button', onClick: @onFavorite.bind(this) },
          svg { className: 'employee-with-buttons__icon', svg: StarIcon }


export default connect(mapStateToProps, mapDispatchToProps)(EmployeeWithButtons)
