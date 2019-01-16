import React from 'react'
import classNames from 'classnames'
import { connect } from 'react-redux'

import { setBirthdayPeriodByShortcut } from '@actions/birthday_period'
import { setResultsSource } from '@actions/search'
import { popSearchResults } from '@actions/layout'

span = React.createFactory('span')


mapStateToProps = (state, ownProps) ->
  {}

mapDispatchToProps = (dispatch, ownProps) ->
  setBirthdayPeriodByShortcut: ->
    dispatch(setBirthdayPeriodByShortcut(ownProps.shortcut))
    dispatch(setResultsSource('birthday'))
    dispatch(popSearchResults())


class BirthdayShortcut extends React.Component

  onClick: ->
    @props.setBirthdayPeriodByShortcut()


  render: ->
    classes =
      'birthday-shortcut' : true
    classes[@props.className] = true

    span { className: classNames(classes), onClick: @onClick.bind(this) },
      @props.children


export default connect(mapStateToProps, mapDispatchToProps)(BirthdayShortcut)
