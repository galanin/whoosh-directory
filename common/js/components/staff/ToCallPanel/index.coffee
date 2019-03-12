import React from 'react'
import { connect } from 'react-redux'
import classNames from 'classnames'

import { popToCall } from '@actions/layout'

import SvgIcon from '@components/common/SvgIcon'
import ToCallIcon from '@icons/call.svg'
import CheckedIcon from '@icons/checked.svg'

div = React.createFactory('div')
span = React.createFactory('span')
svg = React.createFactory(SvgIcon)


mapStateToProps = (state, ownProps) ->
  counter: state.to_call?.unchecked?.length || 0


mapDispatchToProps = (dispatch, ownProps) ->
  clickToCallList: ->
    dispatch(popToCall())


class ToCallPanel extends React.Component

  onClick: ->
    @props.clickToCallList()


  render: ->
    class_names =
      'to-call-panel' : true
      'to-call-panel_counter-highlighted' : @props.counter > 0
    class_names[@props.className] = true

    div { className: classNames(class_names), onClick: @onClick.bind(this) },
      svg { className: 'medium-icon to-call-panel__icon', svg: ToCallIcon }
      span { className: 'to-call-panel__title' },
        'Планировщик'
      if @props.counter > 0
        span { className: 'to-call-panel__counter' },
          @props.counter
      else
        svg { className: 'to-call-panel__empty', svg: CheckedIcon }


export default connect(mapStateToProps, mapDispatchToProps)(ToCallPanel)
