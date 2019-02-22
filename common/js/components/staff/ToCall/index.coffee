import React from 'react'
import { connect } from 'react-redux'
import classNames from 'classnames'

import SvgIcon from '@components/common/SvgIcon'
import {
  addEmploymentToCall
  addContactToCall
  checkEmploymentToCall
  checkContactToCall
  destroyEmploymentToCall
  destroyContactToCall
} from '@actions/to_call'


div = React.createFactory('div')
svg = React.createFactory(SvgIcon)

import Employee from '@components/staff/Employee'
employee = React.createFactory(Employee)

import Contact from '@components/staff/Contact'
contact = React.createFactory(Contact)

import CheckIcon from '@icons/checked.svg'
import DestroyIcon from '@icons/recycle-bin.svg'


mapStateToProps = (state, ownProps) ->
  to_call = state.to_call?.data?[ownProps.to_call_id]

  is_unchecked = if to_call.employment_id?
    state.to_call.unchecked_employment_index[to_call.employment_id]
  else if to_call.contact_id?
    state.to_call.unchecked_contact_index[to_call.contact_id]

  to_call      : to_call
  is_unchecked : is_unchecked


mapDispatchToProps = (dispatch, ownProps) ->
  addToCall: (to_call) ->
    if to_call.employment_id?
      dispatch(addEmploymentToCall(to_call.employment_id))
    else if to_call.contact_id?
      dispatch(addContactToCall(to_call.contact_id))

  checkToCall: (to_call) ->
    if to_call.employment_id?
      dispatch(checkEmploymentToCall(to_call.employment_id))
    else if to_call.contact_id?
      dispatch(checkContactToCall(to_call.contact_id))

  destroyToCall: (to_call) ->
    if to_call.employment_id?
      dispatch(destroyEmploymentToCall(to_call.employment_id))
    else if to_call.contact_id?
      dispatch(destroyContactToCall(to_call.contact_id))


class ToCall extends React.Component

  onCheck: ->
    if @props.is_unchecked
      @props.checkToCall(@props.to_call)
    else
      @props.addToCall(@props.to_call)


  onDestroyToCall: ->
    @props.destroyToCall(@props.to_call)


  render: ->
    return '' unless @props.to_call?

    class_names =
      'to-call' : true
      'employee-buttons-container' : true
      'to-call_is-checked' : !@props.is_unchecked
    class_names[@props.className] = true

    div { className: classNames(class_names) },

      if @props.to_call.employment_id?
        employee employment_id: @props.to_call.employment_id, className: 'to-call__employee'

      if @props.to_call.contact_id?
        contact contact_id: @props.to_call.contact_id, className: 'to-call__contact'

      div { className: 'to-call__buttons employee-buttons-container__buttons' },
        div { className: 'to-call__button to-call__check-to-call employee-buttons-container__button', onClick: @onCheck.bind(this) },
          svg { className: 'to-call__icon to-call__check', svg: CheckIcon }

        div { className: 'to-call__button to-call__destroy-to-call employee-buttons-container__button', onClick: @onDestroyToCall.bind(this) },
          svg { className: 'to-call__icon to-call__destroy', svg: DestroyIcon }


export default connect(mapStateToProps, mapDispatchToProps)(ToCall)
