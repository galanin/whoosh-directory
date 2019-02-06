import React from 'react'
import { connect } from 'react-redux'
import classNames from 'classnames'

import SvgIcon from '@components/common/SvgIcon'
import { addToCall, checkToCall } from '@actions/to_call'


div = React.createFactory('div')
svg = React.createFactory(SvgIcon)

import Employee from '@components/staff/Employee'
employee = React.createFactory(Employee)

import ToCallIcon from '@icons/call.svg'


mapStateToProps = (state, ownProps) ->
  employment : state.employments[ownProps.employment_id]
  is_to_call : state.to_call?.unchecked_employment_index?[ownProps.employment_id]


mapDispatchToProps = (dispatch, ownProps) ->
  addToCall: ->
    dispatch(addToCall(ownProps.employment_id))

  checkToCall: ->
    dispatch(checkToCall(ownProps.employment_id))


class EmployeeWithButtons extends React.Component

  onAddToCall: ->
    if @props.is_to_call
      @props.checkToCall()
    else
      @props.addToCall()


  render: ->
    class_names =
      'employee-with-buttons' : true
      'employee-buttons-container' : true
      'employee-with-buttons_is-to-call-scheduled' : @props.is_to_call
    class_names[@props.className] = true

    div { className: classNames(class_names) },
      employee employment_id: @props.employment_id, hide: @props.hide, className: 'employee-with-buttons__employee'
      div { className: 'employee-with-buttons__buttons employee-buttons-container__buttons' },
        div { className: 'employee-with-buttons__button employee-with-buttons__add-to-call employee-buttons-container__button', onClick: @onAddToCall.bind(this) },
          svg { className: 'employee-with-buttons__icon employee-with-buttons__to-call', svg: ToCallIcon }


export default connect(mapStateToProps, mapDispatchToProps)(EmployeeWithButtons)
