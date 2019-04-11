import React from 'react'
import { connect } from 'react-redux'
import SvgIcon from '@components/common/SvgIcon'
import Silhouette from '@components/contact_info/CommonSilhouette'
import SomeoneButtons from '@components/common/SomeoneButtons'
import Phones from '@components/contact_info/Phones'
import Email from '@components/contact_info/Email'
import OfficeLocation from '@components/contact_info/OfficeLocation'
import LunchBreak from '@components/contact_info/LunchBreak'
import Birthday from '@components/contact_info/Birthday'
import IconedData from '@components/contact_info/IconedData'
import ComboUnitEmployee from '@components/staff/ComboUnitEmployee'
import { reverse } from 'lodash'

import { setCurrentEmploymentId } from '@actions/current'
import { sinkEmployeeInfo, popUnitInfo, popStructure } from '@actions/layout'
import { goToUnitInStructure } from '@actions/units'
import { getParentIds } from '@actions/employments'
import { currentTime, todayDate } from '@lib/datetime'

div = React.createFactory('div')
span = React.createFactory('span')
a = React.createFactory('a')
img = React.createFactory('img')
svg = React.createFactory(SvgIcon)
silhouette = React.createFactory(Silhouette)
buttons = React.createFactory(SomeoneButtons)
phones = React.createFactory(Phones)
email = React.createFactory(Email)
location = React.createFactory(OfficeLocation)
lunch_break = React.createFactory(LunchBreak)
birthday = React.createFactory(Birthday)
iconed_data = React.createFactory(IconedData)
combo_unit_employee = React.createFactory(ComboUnitEmployee)

import CloseButton from '@icons/close_button.svg'
import VacationIcon from '@icons/vacation.svg'


mapStateToProps = (state, ownProps) ->
  employment_id = state.current.employment_id
  employment = state.employments[employment_id]

  employment_id: employment_id
  employment: employment
  person: state.people[employment?.person_id]
  dept_id: employment?.dept_id
  dept: state.units[employment?.dept_id]
  unit_id: employment?.unit_id
  unit: state.units[employment?.unit_id]
  parent_ids: employment? && reverse(getParentIds(state, employment))


mapDispatchToProps = (dispatch) ->
  unsetCurrentEmployee: ->
    dispatch(sinkEmployeeInfo())
    dispatch(setCurrentEmploymentId(null))
  onUnitClick: (unit_id) ->
    dispatch(goToUnitInStructure(unit_id))
    dispatch(popUnitInfo())
    dispatch(popStructure())


class EmployeeInfo extends React.Component

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
    @interval = setInterval((() => @setCurrentTime()), 10000)


  componentWillUnmount: ->
    clearInterval(@interval)


  onCloseButtonClick: ->
    @props.unsetCurrentEmployee()


  onUnitClick: (e) ->
    e.preventDefault()
    @props.onUnitClick(@props.unit_id)


  onDeptClick: (e) ->
    e.preventDefault()
    @props.onUnitClick(@props.dept_id)


  render: ->
    div { className: 'employee-info-container soft-shadow plug' },
      div { className: 'employee-info__close-button', onClick: @onCloseButtonClick.bind(this) },
        svg { className: 'employee-info__close-button-cross', svg: CloseButton }

      div { className: 'employee-info-scroller' },

        if @props.employment?

          div { className: 'employee-info' },
            div { className: 'employee-info__head' },
              div { className: 'employee-info__name' },
                @props.person.last_name + ' ' + @props.person.first_name + ' ' + @props.person.middle_name
            div { className: 'employee-info__post_title' },
              @props.employment.post_title

            if @props.dept_id? and @props.dept_id != @props.unit_id and @props.dept?
              a { className: 'employee-info__unit_title', onClick: @onDeptClick.bind(this), href: '/' },
                @props.dept.list_title

            if @props.unit?
              a { className: 'employee-info__unit_title', onClick: @onUnitClick.bind(this), href: '/' },
                @props.unit.list_title

            div { className: 'employee-info__two-columns' },
              div { className: 'employee-info__photo' },
                if @props.person.photo.large.url
                  img { src: process.env.PHOTO_BASE_URL + @props.person.photo.large.url, className: 'employee-info__photo-large' }
                else
                  silhouette { className: 'employee-info__avatar', gender: @props.person.gender }

              div { className: 'employee-info__data' },
                buttons { employment_id: @props.employment_id }

                phones { format_phones: @props.employment.format_phones, className: 'employee-info__iconed-data employee-info__phones' }

                email { email: @props.person.email, className: 'employee-info__iconed-data employee-info__email' }

                location { building: @props.employment.building, office: @props.employment.office, className: 'employee-info__iconed-data employee-info__location' }

                lunch_break { lunch_begin: @props.employment.lunch_begin, lunch_end: @props.employment.lunch_end, highlighted: ! @props.employment.on_vacation and @isOnLunchNow(), className: 'employee-info__iconed-data employee-info__lunch-break' }

                birthday { birthday_formatted: @props.person.birthday_formatted, highlighted: @isBirthday(), className: 'employee-info__iconed-data employee-info__birthday' }

                if @props.employment.on_vacation
                  iconed_data { className: 'employee-info__iconed-data employee-info__vacation', icon: VacationIcon, align_icon: 'middle' },
                    'В отпуске'

            if @props.parent_ids?.length > 0
              div { className: 'employee-info__structure' },
                div { className: 'employee-info__structure-title' },
                  'Оргструктура'
                div { className: 'employee-info__structure-units' },
                  for parent in @props.parent_ids
                    combo_unit_employee(key: parent.unit_id, unit_id: parent.unit_id, employment_id: parent.employment_id, className: 'list-item hair-border')


export default connect(mapStateToProps, mapDispatchToProps)(EmployeeInfo)
