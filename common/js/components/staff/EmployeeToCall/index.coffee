import React from 'react'
import { connect } from 'react-redux'
import classNames from 'classnames'

import SvgIcon from '@components/common/SvgIcon'
import { addToCall, checkToCall, destroyToCall } from '@actions/to_call'


div = React.createFactory('div')
svg = React.createFactory(SvgIcon)

import Employee from '@components/staff/Employee'
employee = React.createFactory(Employee)

import CheckIcon from '@icons/checked.svg'
import DestroyIcon from '@icons/recycle-bin.svg'


mapStateToProps = (state, ownProps) ->
  to_call = state.to_call?.data?[ownProps.to_call_id]

  to_call      : to_call
  is_unchecked : state.to_call?.unchecked_employment_index?[to_call?.employment_id]


mapDispatchToProps = (dispatch, ownProps) ->
  addToCall: (employment_id) ->
    dispatch(addToCall(employment_id))

  checkToCall: (employment_id) ->
    dispatch(checkToCall(employment_id))

  destroyToCall: (employment_id) ->
    dispatch(destroyToCall(employment_id))


class EmployeeToCall extends React.Component

  onCheck: ->
    if @props.is_unchecked
      @props.checkToCall(@props.to_call.employment_id)
    else
      @props.addToCall(@props.to_call.employment_id)


  onDestroyToCall: ->
    @props.destroyToCall(@props.to_call.employment_id)


  render: ->
    return '' unless @props.to_call?

    class_names =
      'employee-to-call' : true
      'employee-buttons-container' : true
      'employee-to-call_is-checked' : !@props.is_unchecked
    class_names[@props.className] = true

    hide = Object.assign({ to_call: true }, @props.hide)

    div { className: classNames(class_names) },
      employee employment_id: @props.to_call.employment_id, hide: hide, className: 'employee-to-call__employee'
      div { className: 'employee-to-call__buttons employee-buttons-container__buttons' },
        div { className: 'employee-to-call__button employee-to-call__check-to-call employee-buttons-container__button', onClick: @onCheck.bind(this) },
          svg { className: 'employee-to-call__icon employee-to-call__check', svg: CheckIcon }
        div { className: 'employee-to-call__button employee-to-call__destroy-to-call employee-buttons-container__button', onClick: @onDestroyToCall.bind(this) },
          svg { className: 'employee-to-call__icon employee-to-call__destroy', svg: DestroyIcon }


export default connect(mapStateToProps, mapDispatchToProps)(EmployeeToCall)
