import React from 'react'
import PropTypes from 'prop-types'
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import classNames from 'classnames'
import InlineSVG from 'react-svg-inline'

import { loadUnitInfo } from '@actions/units'

div = React.createFactory('div')
span = React.createFactory('span')
svg = React.createFactory(InlineSVG)

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
  F: [
    LeaderMan
    SpecialistMan
    EmployeeMan
    WorkerMan
    AuxiliaryWorkerMan
  ]
  M: [
    LeaderWoman
    SpecialistWoman
    EmployeeWoman
    WorkerWoman
    AuxiliaryWorkerWoman
  ]


mapStateToProps = (state, ownProps) ->
  console.log ownProps.employment_id, state.employments[ownProps.employment_id]
  employment = state.employments[ownProps.employment_id]
  employment: employment
  person: state.people[employment.person_id]
  unit: state.organization_units[employment.unit_id]

mapDispatchToProps = (dispatch, ownProps) ->
  showEmployee: -> dispatch()


class Employee extends React.Component

  onEmployeeClick: ->


  render: ->
    div { className: 'employee', onClick: @onEmployeeClick.bind(this) },
      div { className: 'employee__photo' },
        div { className: 'employee__avatar' },
          avatar = avatars[@props.person.gender][@props.employment.category]
          if avatar?
            svg { svg: avatar }

      div { className: 'employee__info' },
        div { className: 'employee__name' },
          span { className: 'employee__last-name' },
            @props.person.last_name
          span { className: 'employee__first-name' },
            @props.person.first_name
          span { className: 'employee__middle-name' },
            @props.person.middle_name
        div { className: 'employee__post_title' },
          @props.employment.post
        div { className: 'employee__organization_unit_title' },
          @props.unit.list_title

      div { className: 'employee__phones' },
        for phone in @props.employment.phones[0..2]
          div { className: 'employee__phone', key: phone },
            phone


ConnectedEmployee = connect(mapStateToProps, mapDispatchToProps)(Employee)
employee = React.createFactory(ConnectedEmployee)

export default ConnectedEmployee
