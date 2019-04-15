import React from 'react'
import { connect } from 'react-redux'
import { isArray } from 'lodash'
import classNames from 'classnames'

import { loadUnitInfo } from '@actions/units'
import { setCurrentEmploymentId } from '@actions/current'
import { popEmployeeInfo } from '@actions/layout'
import { currentTime, todayDate } from '@lib/datetime'

import SvgIcon from '@components/common/SvgIcon'
import ToCallIcon from '@icons/call.svg'
import StarIcon from '@icons/star.svg'

div = React.createFactory('div')
span = React.createFactory('span')
img = React.createFactory('img')
svg = React.createFactory(SvgIcon)

import CommonAvatar from '@components/staff/CommonAvatar'
avatar = React.createFactory(CommonAvatar)


mapStateToProps = (state, ownProps) ->
  employment = state.employments[ownProps.employment_id]

  employment: employment
  person: employment && state.people[employment.person_id]
  unit_id: employment?.unit_id
  unit: employment && state.units[employment.unit_id]
  dept_id: employment?.dept_id
  dept: state.units[employment?.dept_id]
  current_employment_id: state.current.employment_id
  is_to_call  : state.to_call.unchecked_employment_index[ownProps.employment_id]?
  is_favorite : state.favorites.employment_index[ownProps.employment_id]?


mapDispatchToProps = (dispatch, ownProps) ->
  setCurrentEmployee: ->
    dispatch(setCurrentEmploymentId(ownProps.employment_id))
    dispatch(popEmployeeInfo())


class Employee extends React.Component

  setCurrentTime: ->
    @setState
      current_time: currentTime()
      current_date: todayDate()


  isOnLunchNow: ->
    if @props.employment?.lunch_begin? and @props.employment?.lunch_end? and @state?.current_time?
      @props.employment.lunch_begin <= @state.current_time < @props.employment.lunch_end


  isBirthday: ->
    if @props.person?.birthday? and @state?.current_date
      @props.person.birthday == @state.current_date


  componentDidMount: ->
    @setCurrentTime()
    @interval = setInterval((() => @setCurrentTime()), 30000)


  componentWillUnmount: ->
    clearInterval(@interval)


  onContactClick: ->
    @props.setCurrentEmployee()


  render: ->
    return '' unless @props.employment? and @props.person?

    photo = @props.person.photo

    class_names =
      'employee' : true
      'employee_highlighted' : @props.employment.id == @props.current_employment_id
    class_names[@props.className] = true

    div { className: classNames(class_names), onClick: @onContactClick.bind(this) },
      div { className: 'employee__photo' },
        if photo.thumb45.url? || photo.thumb60.url?
          if photo.thumb45.url?
            img { src: process.env.PHOTO_BASE_URL + photo.thumb45.url, className: 'employee__thumb45' }
          if photo.thumb60.url?
            img { src: process.env.PHOTO_BASE_URL + photo.thumb60.url, className: 'employee__thumb60' }
        else
            avatar { className: 'employee__avatar', gender: @props.person.gender, post_code: @props.employment.post_code }

      div { className: 'employee__info' },
        div { className: 'employee__name' },
          span { className: 'employee__last-name' },
            @props.person.last_name
          span { className: 'employee__first-name' },
            @props.person.first_name
          span { className: 'employee__middle-name' },
            @props.person.middle_name

          if @props.is_to_call
            svg { className: 'small-icon employee__to-call', svg: ToCallIcon }

          if @props.is_favorite
            svg { className: 'small-icon employee__favorite', svg: StarIcon }

        unless @props.hide?.post
          div { className: 'employee__post_title' },
            @props.employment.post_title

        unless @props.hide?.unit
          div { className: 'employee__organization_unit_title' },
            if @props.dept_id?
              if @props.dept?
                @props.dept.list_title
            else
              if @props.unit?
                @props.unit.list_title

      if isArray(@props.employment.format_phones) and @props.employment.format_phones.length > 0
        div { className: 'employee__phones' },
          for phone in @props.employment.format_phones[0..2]
            div { className: 'employee__phone', key: phone[1] },
              phone[1]

      div { className: 'employee__status-container' },
        if @props.employment.on_vacation
          div { className: 'employee__status employee__on-vacation' },
            'В отпуске'
        else
          if @isOnLunchNow()
            div { className: 'employee__status employee__on-lunch' },
              'Обеденный перерыв'
        unless @props.hide?.birthday
          if @isBirthday()
            div { className: 'employee__status employee__birthday' },
              'День рождения'


ConnectedEmployee = connect(mapStateToProps, mapDispatchToProps)(Employee)
employee = React.createFactory(ConnectedEmployee)

export default ConnectedEmployee
