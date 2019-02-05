import React from 'react'
import { connect } from 'react-redux'
import classNames from 'classnames'

import SvgIcon from '@components/common/SvgIcon'
import ToCallIcon from '@icons/call.svg'

import { addToCall, checkToCall } from '@actions/to_call'

div = React.createFactory('div')
span = React.createFactory('span')
svg = React.createFactory(SvgIcon)


mapStateToProps = (state, ownProps) ->
  employment : state.employments[ownProps.employment_id]
  is_to_call : state.to_call?.unchecked_employment_index?[ownProps.employment_id]


mapDispatchToProps = (dispatch, ownProps) ->
  addToCall: ->
    dispatch(addToCall(ownProps.employment_id))

  checkToCall: ->
    dispatch(checkToCall(ownProps.employment_id))


class EmployeeButtons extends React.Component

  onAddToCall: ->
    if @props.is_to_call
      @props.checkToCall()
    else
      @props.addToCall()


  render: ->
    class_names =
      'employee-buttons' : true
      'employee-buttons_is-to-call-scheduled' : @props.is_to_call
    class_names[@props.className] = true

    div { className: classNames(class_names) },
      div { className: 'employee-buttons__button employee-buttons__to-call', onClick: @onAddToCall.bind(this) },
        svg { className: 'employee-buttons__icon employee-buttons__to-call', svg: ToCallIcon }
        span { className: 'employee-buttons__label' },
          if @props.is_to_call
            'Запланирован звонок'
          else
            'Запланировать звонок'


export default connect(mapStateToProps, mapDispatchToProps)(EmployeeButtons)
