import React from 'react'
import PropTypes from 'prop-types'
import { connect } from 'react-redux';

import { loadUnitInfo } from '@actions/units'
import { setCurrentEmploymentId } from '@actions/current'
import { popEmployeeInfo } from '@actions/layout'

div = React.createFactory('div')
span = React.createFactory('span')
img = React.createFactory('img')

import CommonAvatar from '@components/staff/CommonAvatar'
avatar = React.createFactory(CommonAvatar)


mapStateToProps = (state, ownProps) ->
  employment = state.employments[ownProps.employment_id]
  employment: employment
  person: employment && state.people[employment.person_id]
  unit: employment && state.units[employment.unit_id]

mapDispatchToProps = (dispatch, ownProps) ->
  setCurrentEmployee: ->
    dispatch(setCurrentEmploymentId(ownProps.employment_id))
    dispatch(popEmployeeInfo())


class Employee extends React.Component

  onEmployeeClick: ->
    @props.setCurrentEmployee()


  render: ->
    return '' unless @props.employment

    photo = @props.person.photo

    div { className: 'employee', onClick: @onEmployeeClick.bind(this) },
      div { className: 'employee__photo' },
        if photo.thumb45.url? || photo.thumb60.url?
          if photo.thumb45.url?
            img { src: process.env.PHOTO_BASE_URL + photo.thumb45.url, className: 'employee__thumb45' }
          if photo.thumb60.url?
            img { src: process.env.PHOTO_BASE_URL + photo.thumb60.url, className: 'employee__thumb60' }
        else
            avatar { className: 'employee__avatar', gender: @props.person.gender, post_category_code: @props.employment.post_category_code }

      div { className: 'employee__info' },
        div { className: 'employee__name' },
          span { className: 'employee__last-name' },
            @props.person.last_name
          span { className: 'employee__first-name' },
            @props.person.first_name
          span { className: 'employee__middle-name' },
            @props.person.middle_name
        div { className: 'employee__post_title' },
          @props.employment.post_title
        unless @props.hide?.unit
          div { className: 'employee__organization_unit_title' },
            @props.unit.list_title

      div { className: 'employee__phones' },
        for phone in @props.employment.phones[0..2]
          div { className: 'employee__phone', key: phone },
            phone


ConnectedEmployee = connect(mapStateToProps, mapDispatchToProps)(Employee)
employee = React.createFactory(ConnectedEmployee)

export default ConnectedEmployee
