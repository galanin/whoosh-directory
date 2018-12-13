import React from 'react'
import { connect } from 'react-redux'
import SvgIcon from '@components/common/SvgIcon'
import Silhouette from '@components/contact_info/CommonSilhouette'
import Phones from '@components/contact_info/Phones'
import Email from '@components/contact_info/Email'
import OfficeLocation from '@components/contact_info/OfficeLocation'
import LunchBreak from '@components/contact_info/LunchBreak'
import Birthday from '@components/contact_info/Birthday'

import { setCurrentEmploymentId, setCurrentUnitId } from '@actions/current'
import { sinkEmployeeInfo, popUnitInfo, popStructure } from '@actions/layout'
import { resetExpandedSubUnits } from '@actions/expand_sub_units'
import { loadUnitExtra } from '@actions/unit_extras'
import { goToUnitInStructure } from '@actions/units'

div = React.createFactory('div')
span = React.createFactory('span')
a = React.createFactory('a')
img = React.createFactory('img')
svg = React.createFactory(SvgIcon)
silhouette = React.createFactory(Silhouette)
phones = React.createFactory(Phones)
email = React.createFactory(Email)
location = React.createFactory(OfficeLocation)
lunch_break = React.createFactory(LunchBreak)
birthday = React.createFactory(Birthday)

import CloseButton from '@icons/close_button.svg'
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
          div { className: 'employee-info__photo' },
            if @props.person.photo.large.url
              img { src: process.env.PHOTO_BASE_URL + @props.person.photo.large.url, className: 'employee-info__photo-large' }
            else
              silhouette { className: 'employee-info__avatar', gender: @props.person.gender }

          div { className: 'employee-info__data' },
            phones { format_phones: @props.employment.format_phones, className: 'employee-info__iconed-data employee-info__phones' }

            email { email: @props.person.email, className: 'employee-info__iconed-data employee-info__email' }

            location { building: @props.employment.building, office: @props.employment.office, className: 'employee-info__iconed-data employee-info__location' }

            lunch_break { lunch_begin: @props.employment.lunch_begin, lunch_end: @props.employment.lunch_end, className: 'employee-info__iconed-data employee-info__lunch-break' }

            birthday { birthday_formatted: @props.person.birthday_formatted, className: 'employee-info__iconed-data employee-info__birthday' }

            if @props.employment.on_vacation
              div { className: 'employee-info__iconed-data employee-info__vacation' },
                svg { className: 'employee-info__data-icon employee-info__vacation-icon', svg: Vacation }
                div { className: 'employee-info__data-container employee-info__vacation-container' },
                  div { className: 'employee-info__data-data employee-info__vacation-data' },
                    'В отпуске'


export default connect(mapStateToProps, mapDispatchToProps)(EmployeeInfo)
