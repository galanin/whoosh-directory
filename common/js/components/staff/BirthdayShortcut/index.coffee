import React from 'react'
import classNames from 'classnames'
import { connect } from 'react-redux'

import { showBirthdayShortcutPeriod, loadBirthdays } from '@actions/birthdays'
import { popSearchResults } from '@actions/layout'

span = React.createFactory('span')


mapStateToProps = (state, ownProps) ->
  {}

mapDispatchToProps = (dispatch, ownProps) ->
  showBirthdayShortcutPeriod: ->
    dispatch(showBirthdayShortcutPeriod(ownProps.shortcut))
    dispatch(popSearchResults())


class BirthdayShortcut extends React.Component

  onClick: ->
    @props.showBirthdayShortcutPeriod()


  render: ->
    classes =
      'birthday-shortcut' : true
    classes[@props.className] = true

    span { className: classNames(classes), onClick: @onClick.bind(this) },
      @props.children


export default connect(mapStateToProps, mapDispatchToProps)(BirthdayShortcut)
