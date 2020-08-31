import React from 'react'
import { connect } from 'react-redux'
import { isArray } from 'lodash'
import classNames from 'classnames'

import { loadUnitInfo } from '@actions/units'
import { setCurrentContactId } from '@actions/current'
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
  contact = state.contacts[ownProps.contact_id]
  contact: contact
  node: state.nodes.tree[contact?.node_id]
  current_contact_id: state.current.contact_id
  is_to_call  : state.to_call.unchecked_contact_index[ownProps.contact_id]?
  is_favorite : state.favorites.contact_index[ownProps.contact_id]?
  show_location: state.settings.search_results__show_location


mapDispatchToProps = (dispatch, ownProps) ->
  setCurrentContact: ->
    dispatch(setCurrentContactId(ownProps.contact_id))
    dispatch(popEmployeeInfo())


class Contact extends React.Component

  isOnLunchNow: ->
    if @props.contact?.lunch_begin? and @props.contact?.lunch_end? and @state?.current_time?
      @props.contact.lunch_begin <= @state.current_time < @props.contact.lunch_end


  isBirthday: ->
    if @props.person?.birthday? and @state?.current_date
      @props.person.birthday == @state.current_date


  setCurrentTime: ->
    @setState
      current_time: currentTime()
      current_date: todayDate()


  componentDidMount: ->
    @setCurrentTime()
    @interval = setInterval((() => @setCurrentTime()), 30000)


  componentWillUnmount: ->
    clearInterval(@interval)


  onContactClick: ->
    @props.setCurrentContact()


  render: ->
    return '' unless @props.contact

    photo = @props.contact.photo

    class_names =
      'employee' : true
      'contact' : true
      'employee_highlighted' : @props.contact.id == @props.current_contact_id
      'contact_highlighted' : @props.contact.id == @props.current_contact_id
    class_names[@props.className] = true

    div { className: classNames(class_names), onClick: @onContactClick.bind(this) },
      div { className: 'employee__photo' },
        if photo.thumb45.url? || photo.thumb60.url?
          if photo.thumb45.url?
            img { src: process.env.PHOTO_BASE_URL + photo.thumb45.url, className: 'employee__thumb45' }
          if photo.thumb60.url?
            img { src: process.env.PHOTO_BASE_URL + photo.thumb60.url, className: 'employee__thumb60' }
        else
          avatar { className: 'employee__avatar', gender: @props.contact.gender, post_code: @props.contact.post_code }

      div { className: 'employee__info' },
        div { className: 'employee__name' },
          if @props.contact.last_name
            [
              span { className: 'employee__last-name' },
                @props.contact.last_name
              span { className: 'employee__first-name' },
                @props.contact.first_name
              span { className: 'employee__middle-name' },
                @props.contact.middle_name
            ]
          else if @props.contact.function_title
            @props.contact.function_title
          else if @props.contact.location_title
            @props.contact.location_title

          if @props.is_to_call
            svg { className: 'small-icon employee__to-call', svg: ToCallIcon }

          if @props.is_favorite
            svg { className: 'small-icon employee__favorite', svg: StarIcon }

        if @props.contact.post_title
          div { className: 'employee__post_title' },
            @props.contact.post_title

        unless @props.hide?.unit
          if @props.node?
            div { className: 'employee__organization_unit_title' },
              @props.node.t

        if @props.show_location
          div { className: 'employee__location' },
            if @props.contact.building
              span { className: 'employee__location-building' },
                span { className: 'employee__location-building-label' },
                  'Корпус '
                span { className: 'employee__location-building-number' },
                  @props.contact.building
            if @props.contact.office
              span { className: 'employee__location-office' },
                span { className: 'employee__location-office-label' },
                  if @props.contact.building
                    ', кабинет '
                  else
                    'Кабинет '
                span { className: 'employee__location-office-number' },
                  @props.contact.office

      if isArray(@props.contact.format_phones) and @props.contact.format_phones.length > 0
        div { className: 'employee__phones' },
          for phone in @props.contact.format_phones[0..2]
            div { className: 'employee__phone', key: phone[1] },
              phone[1]

      div { className: 'employee__status-container' },
        if @props.contact.on_vacation
          div { className: 'employee__status employee__on-vacation' },
            'В отпуске'
        else
          if @isOnLunchNow()
            div { className: 'employee__status employee__on-lunch' },
              'Обеденный перерыв'
        if @isBirthday()
          div { className: 'employee__status employee__birthday' },
            'День рождения'


ConnectedContact = connect(mapStateToProps, mapDispatchToProps)(Contact)
contact = React.createFactory(ConnectedContact)

export default ConnectedContact
