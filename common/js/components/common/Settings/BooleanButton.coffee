import React from 'react'
import { connect } from 'react-redux'
import classNames from 'classnames'
import SvgIcon from '@components/common/SvgIcon'

import { saveSetting } from '@actions/settings'

a = React.createFactory('a')
div = React.createFactory('div')
svg = React.createFactory(SvgIcon)


mapStateToProps = (state, ownProps) ->
  is_checked: state.settings[ownProps.setting]


mapDispatchToProps = (dispatch, ownProps) ->
  check: ->
    dispatch(saveSetting(ownProps.setting, true))
  uncheck: ->
    dispatch(saveSetting(ownProps.setting, false))


class SettingsBooleanButton extends React.Component

  onClick: ->
    if @props.is_checked
      @props.uncheck()
    else
      @props.check()


  render: ->

    class_name = classNames
      'settings-boolean-button': true
      'settings-boolean-button-checked': this.props.is_checked

    svg { className: class_name, svg: @props.svg, onClick: @onClick.bind(this) }


export default connect(mapStateToProps, mapDispatchToProps)(SettingsBooleanButton)
