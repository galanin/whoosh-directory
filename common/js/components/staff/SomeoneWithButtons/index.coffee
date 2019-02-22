import React from 'react'
import { connect } from 'react-redux'
import classNames from 'classnames'
import { clone } from 'lodash'

import SvgIcon from '@components/common/SvgIcon'

import { addEmploymentToCall, addContactToCall, checkEmploymentToCall, checkContactToCall } from '@actions/to_call'
import { addFavoriteEmployment, addFavoriteContact, removeFavoriteEmployment, removeFavoriteContact } from '@actions/favorites'


div = React.createFactory('div')
svg = React.createFactory(SvgIcon)

import Employee from '@components/staff/Employee'
employee = React.createFactory(Employee)

import Contact from '@components/staff/Contact'
contact = React.createFactory(Contact)

import ToCallIcon from '@icons/call.svg'
import StarIcon from '@icons/star.svg'


mapStateToProps = (state, ownProps) ->
  if ownProps.employment_id?
    is_to_call  : state.to_call?.unchecked_employment_index?[ownProps.employment_id]
    is_favorite : state.favorites.employment_index[ownProps.employment_id]
  else if ownProps.contact_id?
    is_to_call  : state.to_call?.unchecked_contact_index?[ownProps.contact_id]
    is_favorite : state.favorites.contact_index[ownProps.contact_id]
  else
    {}


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


class SomeoneWithButtons extends React.Component

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
    return '' unless @props.employment_id? or @props.contact_id?

    child_props = clone(@props)
    delete child_props.key

    class_names =
      'employee-with-buttons' : true
      'employee-buttons-container' : true
      'employee-with-buttons_is-to-call-scheduled' : @props.is_to_call
      'employee-with-buttons_is-favorite' : @props.is_favorite
    class_names[@props.className] = true

    div { className: classNames(class_names) },

      if @props.employment_id?
        child_props.className = 'employee-with-buttons__employee'
        employee child_props

      else if @props.contact_id?
        child_props.className = 'employee-with-buttons__contact'
        contact child_props

      div { className: 'employee-with-buttons__buttons employee-buttons-container__buttons' },
        div { className: 'employee-with-buttons__button employee-with-buttons__to-call employee-buttons-container__button', onClick: @onAddToCall.bind(this) },
          svg { className: 'employee-with-buttons__icon', svg: ToCallIcon }

        div { className: 'employee-with-buttons__button employee-with-buttons__favorite employee-buttons-container__button', onClick: @onFavorite.bind(this) },
          svg { className: 'employee-with-buttons__icon', svg: StarIcon }


export default connect(mapStateToProps, mapDispatchToProps)(SomeoneWithButtons)
