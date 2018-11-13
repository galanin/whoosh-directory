import React from 'react'
import PropTypes from 'prop-types'
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { isArray } from 'lodash';
import SvgIcon from '@components/common/SvgIcon'

import { setCurrentEmploymentId, setCurrentUnitId } from '@actions/current'
import { sinkEmployeeInfo, popUnitInfo, popStructure } from '@actions/layout'
import { resetExpandedSubUnits } from '@actions/expand_sub_units'
import { loadUnitExtra } from '@actions/unit_extras'
import { goToUnitInStructure } from '@actions/units'

div = React.createFactory('div')
a = React.createFactory('a')
img = React.createFactory('img')
svg = React.createFactory(SvgIcon)

import CloseButton from '@icons/close_button.svg'
import Location from '@icons/location.svg'
import Lunch from '@icons/lunch.svg'
import Birthday from '@icons/birthday.svg'
import Vacation from '@icons/vacation.svg'


mapStateToProps = (state, ownProps) ->
  employment_id = state.current.employment_id
  employment = state.employments[employment_id]
  employment_id: employment_id
  employment: employment
  person: employment && state.people[employment.person_id]
  unit: employment && state.units[employment.unit_id]

mapDispatchToProps = (dispatch) ->
  unsetCurrentEmployee: ->
    dispatch(sinkEmployeeInfo())
    dispatch(setCurrentEmploymentId(null))
  onUnitClick: (unit_id) ->
    dispatch(setCurrentUnitId(unit_id))
    dispatch(goToUnitInStructure(unit_id))
    dispatch(loadUnitExtra(unit_id))
    dispatch(resetExpandedSubUnits())
    dispatch(popUnitInfo())
    dispatch(popStructure())


class EmployeeInfo extends React.Component

  onCloseButtonClick: ->
    @props.unsetCurrentEmployee()


  onUnitClick: (e) ->
    e.preventDefault()
    @props.onUnitClick(@props.employment.unit_id)


  render: ->
    return '' unless @props.employment

    div { className: 'employee-info-scroller plug' },
      div { className: 'employee-info' },
        div { className: 'employee-info__head' },
          div { className: 'employee-info__name' },
            @props.person.last_name + ' ' + @props.person.first_name + ' ' + @props.person.middle_name
          div { className: 'employee-info__close-button', onClick: @onCloseButtonClick.bind(this) },
            svg { className: 'employee-info__close-button-cross', svg: CloseButton }
        div { className: 'employee-info__post_title' },
          @props.employment.post_title
        a { className: 'employee-info__unit_title', onClick: @onUnitClick.bind(this), href: '/' },
          @props.unit.list_title

        div { className: 'employee-info__two-columns' },
          if @props.person.photo.large.url
            div { className: 'employee-info__photo' },
              img { src: process.env.PHOTO_BASE_URL + @props.person.photo.large.url, className: 'employee-info__photo-large' }
          div { className: 'employee-info__data' },
            if isArray(@props.employment.phones) and @props.employment.phones.length > 0
              div { className: 'employee-info__phones' },
                for phone in @props.employment.phones
                  div { className: 'employee-info__phone', key: phone },
                    phone

            if @props.employment.building? or @props.employment.office?
              div { className: 'employee-info__iconed-data employee-info__location' },
                svg { className: 'employee-info__data-icon employee-info__location-icon', svg: Location }
                div { className: 'employee-info__data-container employee-info__location-container' },
                  div { className: 'employee-info__data-data employee-info__location-data' },
                    if @props.employment.building?
                      div { className: 'employee-info__location-building' },
                        @props.employment.building
                    if @props.employment.office?
                      div { className: 'employee-info__location-office' },
                        @props.employment.office

            if @props.employment.lunch_begin? and @props.employment.lunch_end?
              div { className: 'employee-info__iconed-data employee-info__lunch' },
                svg { className: 'employee-info__data-icon employee-info__lunch-icon', svg: Lunch }
                div { className: 'employee-info__data-container employee-info__lunch-container' },
                  div { className: 'employee-info__data-data employee-info__lunch-data' },
                    @props.employment.lunch_begin + '—' + @props.employment.lunch_end

            if @props.person.birthday_formatted?
              div { className: 'employee-info__iconed-data employee-info__birthday' },
                svg { className: 'employee-info__data-icon employee-info__birthday-icon', svg: Birthday }
                div { className: 'employee-info__data-container employee-info__birthday-container' },
                  div { className: 'employee-info__data-data employee-info__birthday-data' },
                    @props.person.birthday_formatted

            if @props.employment.on_vacation
              div { className: 'employee-info__iconed-data employee-info__vacation' },
                svg { className: 'employee-info__data-icon employee-info__vacation-icon', svg: Vacation }
                div { className: 'employee-info__data-container employee-info__vacation-container' },
                  div { className: 'employee-info__data-data employee-info__vacation-data' },
                    'В отпуске'


export default connect(mapStateToProps, mapDispatchToProps)(EmployeeInfo)
