import React from 'react'
import PropTypes from 'prop-types'
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import classNames from 'classnames'
import SvgIcon from '@components/common/SvgIcon'

import { loadUnitInfo } from '@actions/units'

div = React.createFactory('div')
span = React.createFactory('span')
img = React.createFactory('img')
svg = React.createFactory(SvgIcon)

import LeaderMan from './icons/leader-man.svg'
import LeaderWoman from './icons/leader-woman.svg'
import SpecialistMan from './icons/specialist-man.svg'
import SpecialistWoman from './icons/specialist-woman.svg'
import EmployeeMan from './icons/employee-man.svg'
import EmployeeWoman from './icons/employee-woman.svg'
import WorkerMan from './icons/worker-man.svg'
import WorkerWoman from './icons/worker-woman.svg'
import AuxiliaryWorkerMan from './icons/auxiliary-worker-man.svg'
import AuxiliaryWorkerWoman from './icons/auxiliary-worker-woman.svg'

avatars =
  M: [
    LeaderMan
    SpecialistMan
    EmployeeMan
    WorkerMan
    AuxiliaryWorkerMan
  ]
  F: [
    LeaderWoman
    SpecialistWoman
    EmployeeWoman
    WorkerWoman
    AuxiliaryWorkerWoman
  ]


mapStateToProps = (state, ownProps) ->
  employment = state.employments[ownProps.employment_id]
  employment: employment
  person: employment && state.people[employment.person_id]
  unit: employment && state.units[employment.unit_id]

mapDispatchToProps = (dispatch, ownProps) ->
  showEmployee: -> dispatch()


class Employee extends React.Component

  onEmployeeClick: ->


  render: ->
    return '' unless @props.employment

    avatar = avatars[@props.person.gender][@props.employment.post_category_code]

    div { className: 'employee', onClick: @onEmployeeClick.bind(this) },
      div { className: 'employee__photo' },
        if @props.person.photo.thumb45.url? || @props.person.photo.thumb60.url?
          if @props.person.photo.thumb45.url?
            img { src: process.env.PHOTO_BASE_URL + @props.person.photo.thumb45.url, className: 'employee__thumb45' }
          if @props.person.photo.thumb60.url?
            img { src: process.env.PHOTO_BASE_URL + @props.person.photo.thumb60.url, className: 'employee__thumb60' }
        else
          div { className: 'employee__avatar' },
            if avatar?
              svg { svg: avatar }
            else
              ''

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
        div { className: 'employee__organization_unit_title' },
          @props.unit.list_title

      div { className: 'employee__phones' },
        for phone in @props.employment.phones[0..2]
          div { className: 'employee__phone', key: phone },
            phone


ConnectedEmployee = connect(mapStateToProps, mapDispatchToProps)(Employee)
employee = React.createFactory(ConnectedEmployee)

export default ConnectedEmployee
