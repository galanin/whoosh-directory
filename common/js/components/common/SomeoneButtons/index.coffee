import React from 'react'
import { connect } from 'react-redux'
import classNames from 'classnames'
import { includes } from 'lodash'

import SvgIcon from '@components/common/SvgIcon'

import { addEmploymentToCall, addContactToCall, checkEmploymentToCall, checkContactToCall } from '@actions/to_call'
import { addFavoriteEmployment, addFavoriteContact, removeFavoriteEmployment, removeFavoriteContact } from '@actions/favorites'

div = React.createFactory('div')
span = React.createFactory('span')
svg = React.createFactory(SvgIcon)

import ToCallIcon from '@icons/call.svg'
import StarIcon from '@icons/star.svg'


mapStateToProps = (state, ownProps) ->
  if ownProps.employment_id?
    employment  : state.employments[ownProps.employment_id]
    is_to_call  : state.to_call.unchecked_employment_index[ownProps.employment_id]
    is_favorite : state.favorites.employment_index[ownProps.employment_id]
  else if ownProps.contact_id?
    contact     : state.contacts[ownProps.contact_id]
    is_to_call  : state.to_call.unchecked_contact_index[ownProps.contact_id]
    is_favorite : state.favorites.contact_index[ownProps.contact_id]


mapDispatchToProps = (dispatch, ownProps) ->
  addToCall: ->
    if ownProps.employment_id?
      dispatch(addEmploymentToCall(ownProps.employment_id))
    else if ownProps.contact_id?
      dispatch(addContactToCall(ownProps.contact_id))

  checkToCall: ->
    if ownProps.employment_id?
      dispatch(checkEmploymentToCall(ownProps.employment_id))
    else if ownProps.contact_id?
      dispatch(checkContactToCall(ownProps.contact_id))

  favorite: ->
    if ownProps.employment_id?
      dispatch(addFavoriteEmployment(ownProps.employment_id))
    else if ownProps.contact_id?
      dispatch(addFavoriteContact(ownProps.contact_id))

  unfavorite: ->
    if ownProps.employment_id?
      dispatch(removeFavoriteEmployment(ownProps.employment_id))
    else if ownProps.contact_id?
      dispatch(removeFavoriteContact(ownProps.contact_id))


class SomeoneButtons extends React.Component

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
        svg { className: 'medium-icon employee-buttons__icon', svg: ToCallIcon }
        span { className: 'employee-buttons__label' },
          if @props.is_to_call
            'Запланирован звонок'
          else
            'Запланировать звонок'

      div { className: 'employee-buttons__button employee-buttons__favorite', onClick: @onFavorite.bind(this) },
        svg { className: 'medium-icon employee-buttons__icon', svg: StarIcon }
        span { className: 'employee-buttons__label' },
          if @props.is_favorite
            'В избранном'
          else
            'Добавить в избранное'


export default connect(mapStateToProps, mapDispatchToProps)(SomeoneButtons)
