import React from 'react'
import { connect } from 'react-redux'
import classNames from 'classnames'

import SvgIcon from '@components/common/SvgIcon'
import { addToCall, destroyToCall } from '@actions/to_call'


div = React.createFactory('div')
svg = React.createFactory(SvgIcon)

import Employee from '@components/staff/Employee'
employee = React.createFactory(Employee)

import CheckIcon from '@icons/checked.svg'
import DestroyIcon from '@icons/recycle-bin.svg'


mapStateToProps = (state, ownProps) ->
  to_call = state.to_call?.data?[ownProps.to_call_id]
  employment   : state.employments[to_call.employment_id]
  to_call      : to_call
  is_unchecked : state.to_call?.unchecked_employment_index?[ownProps.employment_id]


mapDispatchToProps = (dispatch, ownProps) ->
  clickAddToCall: ->
    dispatch(addToCall(ownProps.employment_id))

  clickDestroyToCall: ->
    dispatch(destroyToCall(ownProps.employment_id))


class EmployeeWithButtons extends React.Component

  onAddToCall: ->
    @props.clickAddToCall()


  onDestroyToCall: ->
    @props.clickDestroyToCall()


  render: ->
    class_names =
      'employee-with-buttons' : true
    class_names[@props.className] = true

    div { className: classNames(class_names) },
      div { className: 'employee-with-buttons__horizontal' },
        employee employment_id: @props.employment_id, hide: @props.hide, className: 'employee-with-buttons__employee'
        div { className: 'employee-with-buttons__buttons' },
          div { className: 'employee-with-buttons__button employee-with-buttons__add-to-call', onClick: @onAddToCall.bind(this) },
            svg { className: 'employee-with-buttons__icon employee-with-buttons__to-call', svg: CheckIcon }
          if @props.to_call
            div { className: 'employee-with-buttons__button employee-with-buttons__destroy-to-call', onClick: @onAddToCall.bind(this) },
              svg { className: 'employee-with-buttons__icon employee-with-buttons__destroy', svg: DestroyIcon }


export default connect(mapStateToProps, mapDispatchToProps)(EmployeeWithButtons)
