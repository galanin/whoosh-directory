import React from 'react'
import { connect } from 'react-redux';
import SvgIcon from '@components/common/SvgIcon'
import Silhouette from '@components/contact_info/CommonSilhouette'
import Phones from '@components/contact_info/Phones'
import Email from '@components/contact_info/Email'
import OfficeLocation from '@components/contact_info/OfficeLocation'
import LunchBreak from '@components/contact_info/LunchBreak'
import Birthday from '@components/contact_info/Birthday'

import { setCurrentContactId, setCurrentUnitId } from '@actions/current'
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


mapStateToProps = (state, ownProps) ->
  contact_id = state.current.contact_id
  contact = state.contacts[contact_id]
  contact_id: contact_id
  contact: contact
  unit: contact && state.units[contact.unit_id]

mapDispatchToProps = (dispatch) ->
  unsetCurrentContact: ->
    dispatch(sinkEmployeeInfo())
    dispatch(setCurrentContactId(null))
  onUnitClick: (unit_id) ->
    dispatch(setCurrentUnitId(unit_id))
    dispatch(goToUnitInStructure(unit_id))
    dispatch(loadUnitExtra(unit_id))
    dispatch(resetExpandedSubUnits())
    dispatch(popUnitInfo())
    dispatch(popStructure())


class EmployeeInfo extends React.Component

  onCloseButtonClick: ->
    @props.unsetCurrentContact()


  onUnitClick: (e) ->
    e.preventDefault()
    @props.onUnitClick(@props.contact.unit_id)


  render: ->
    div { className: 'employee-info-scroller plug' },

      div { className: 'employee-info contact-info' },

        div { className: 'employee-info__head contact-info__head' },

          div { className: 'employee-info__name contact-info__name' },
            if @props.contact.last_name
              @props.contact.last_name + ' ' + @props.contact.first_name + ' ' + @props.contact.middle_name
            else if @props.contact.function_title
              @props.contact.function_title
            else if @props.contact.location_title
              @props.contact.location_title

          div { className: 'employee-info__close-button', onClick: @onCloseButtonClick.bind(this) },
            svg { className: 'employee-info__close-button-cross', svg: CloseButton }

        div { className: 'employee-info__post_title' },
          @props.contact.post_title

        a { className: 'employee-info__unit_title', onClick: @onUnitClick.bind(this), href: '/' },
          @props.unit.list_title

        div { className: 'employee-info__two-columns' },

          if @props.contact.photo.large.url? or @props.contact.gender?
            div { className: 'employee-info__photo' },
              if @props.contact.photo.large.url?
                img { src: process.env.PHOTO_BASE_URL + @props.contact.photo.large.url, className: 'employee-info__photo-large' }
              else if @props.contact.gender?
                silhouette { className: 'employee-info__avatar', gender: @props.contact.gender }
          else if @props.contact.gender?
            silhouette { className: 'employee-info__avatar', gender: @props.contact.gender }

          div { className: 'employee-info__data' },

            phones { format_phones: @props.contact.format_phones, className: 'employee-info__iconed-data employee-info__phones' }

            email { email: @props.contact.email, className: 'employee-info__iconed-data employee-info__email' }

            location { building: @props.contact.building, office: @props.contact.office, className: 'employee-info__iconed-data employee-info__location' }

            lunch_break { lunch_begin: @props.contact.lunch_begin, lunch_end: @props.contact.lunch_end, className: 'employee-info__iconed-data employee-info__lunch-break' }

            birthday { birthday_formatted: @props.contact.birthday_formatted, className: 'employee-info__iconed-data employee-info__birthday' }


export default connect(mapStateToProps, mapDispatchToProps)(EmployeeInfo)
