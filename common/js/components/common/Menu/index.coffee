import React from 'react'
import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import classNames from 'classnames'

import { RESULTS_SOURCE_BIRTHDAY } from '@constants/search'

import { setBirthdayPeriodByShortcut } from '@actions/birthday_period'
import { setResultsSource } from '@actions/search'

import { closeMenu } from '@actions/menu'
import {
  popSearchResults
  popStructure
  popFavorites
  popToCall
} from '@actions/layout'

import SvgIcon from '@components/common/SvgIcon'

div = React.createFactory 'div'
a = React.createFactory 'a'
svg = React.createFactory(SvgIcon)

import CloseButton from '@icons/close_button.svg'


mapStateToProps = (state, ownProps) ->
  open: state.menu.open


mapDispatchToProps = (dispatch, ownProps) ->
  closeMenu: ->
    dispatch(closeMenu())

  goSearch: ->
    dispatch(popSearchResults())

  goStructure: ->
    dispatch(popStructure())

  goFavorites: ->
    dispatch(popFavorites())

  goToCall: ->
    dispatch(popToCall())

  goBirthdays: (shortcut) ->
    dispatch(setBirthdayPeriodByShortcut(shortcut))
    dispatch(setResultsSource(RESULTS_SOURCE_BIRTHDAY))
    dispatch(popSearchResults())


class Menu extends React.Component

  onCloseButtonClick: (event) ->
    @props.closeMenu()


  onSearchChosen: (event) ->
    event.preventDefault()
    @props.goSearch()
    @props.closeMenu()


  onStructureChosen: (event) ->
    event.preventDefault()
    @props.goStructure()
    @props.closeMenu()


  onFavoritesChosen: (event) ->
    event.preventDefault()
    @props.goFavorites()
    @props.closeMenu()


  onToCallChosen: (event) ->
    event.preventDefault()
    @props.goToCall()
    @props.closeMenu()


  onBirthdaysTodayChosen: (event) ->
    event.preventDefault()
    @props.goBirthdays(event.currentTarget.getAttribute('shortcut'))
    @props.closeMenu()


  render: ->
    class_names =
      'menu'         : true
      'menu_is-open' : @props.open

    div { className: classNames(class_names) },
      div { className: 'menu-scroller' },
        div { className: 'employee-info__close-button', onClick: @onCloseButtonClick.bind(this) },
          svg { className: 'employee-info__close-button-cross', svg: CloseButton }

        div { className: 'menu-title' },
          'Справочник сотрудников'

        a { className: 'menu-item menu-item__search', onClick: @onSearchChosen.bind(this), href: '#' },
          'Поиск'

        a { className: 'menu-item menu-item__structure', onClick: @onStructureChosen.bind(this), href: '#' },
          'Оргструктура'

        a { className: 'menu-item menu-item__structure', onClick: @onFavoritesChosen.bind(this), href: '#' },
          'Избранное'

        a { className: 'menu-item menu-item__structure', onClick: @onToCallChosen.bind(this), href: '#' },
          'Планировщик'

        div { className: 'menu-subtitle' },
          'Дни рождения'

        a { className: 'menu-item menu-item__structure', onClick: @onBirthdaysTodayChosen.bind(this), href: '#', shortcut: 'today' },
          'Сегодня'

        a { className: 'menu-item menu-item__structure', onClick: @onBirthdaysTodayChosen.bind(this), href: '#', shortcut: 'tomorrow' },
          'Будущие'

        a { className: 'menu-item menu-item__structure', onClick: @onBirthdaysTodayChosen.bind(this), href: '#', shortcut: 'recent' },
          'Прошедшие'


export default connect(mapStateToProps, mapDispatchToProps)(Menu)
