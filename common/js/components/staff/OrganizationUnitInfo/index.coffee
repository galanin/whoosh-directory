import React from 'react'
import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import classNames from 'classnames'
import { isArray, includes } from 'lodash'

import { addFavoriteUnit, removeFavoriteUnit } from '@actions/favorites'

import SvgIcon from '@components/common/SvgIcon'

div = React.createFactory('div')
svg = React.createFactory(SvgIcon)

import EmployeeWithButtons from '@components/staff/EmployeeWithButtons'
employee = React.createFactory(EmployeeWithButtons)

import OrganizationSubUnit from '@components/staff/OrganizationSubUnit'
sub_unit = React.createFactory(OrganizationSubUnit)

import Contact from '@components/staff/Contact'
contact = React.createFactory(Contact)

import StarIcon from '@icons/star.svg'


mapStateToProps = (state) ->
  unit_id = state.current.unit_id
  extra = state.unit_extras[unit_id]
  unit_id:     unit_id
  unit_data:   state.units[unit_id]
  unit_titles: state.unit_titles[unit_id] || {}
  loading:     extra?.loading
  loaded:      extra?.loaded
  is_favorite: includes(state.favorites.unit_ids, unit_id)


mapDispatchToProps = (dispatch) ->
  favorite: (unit_id) ->
    dispatch(addFavoriteUnit(unit_id))

  unfavorite: (unit_id) ->
    dispatch(removeFavoriteUnit(unit_id))


class OrganizationUnitInfo extends React.Component
  @propTypes =
    unit_id: PropTypes.integer


  onClickFavorite: ->
    if @props.is_favorite
      @props.unfavorite(@props.unit_id)
    else
      @props.favorite(@props.unit_id)


  render: ->
    return '' unless @props.unit_id?

    class_names =
      'organization-unit' : true
      'organization-unit__scroller' : true
      'organization-unit_is-favorite' : @props.is_favorite
    class_names[@props.className] = true

    div { className: classNames(class_names) },

      if @props.unit_titles.short_title?
        div { className: 'organization-unit__short-title' },
          @props.unit_titles.short_title
          svg { className: 'organization-unit__favorite', svg: StarIcon, onClick: @onClickFavorite.bind(this) }

      if @props.unit_titles.long_title?
        div { className: 'organization-unit__long-title' },
          @props.unit_titles.long_title
          unless @props.unit_titles.short_title?
            svg { className: 'organization-unit__favorite', svg: StarIcon, onClick: @onClickFavorite.bind(this) }

      if isArray(@props.unit_data?.employ_ids)
        div { className: 'organization-unit__employees' },
          for employment_id in @props.unit_data.employ_ids
            employee key: employment_id, employment_id: employment_id, hide: { unit: true }, className: 'list-item shadow'

      if isArray(@props.unit_data?.contact_ids)
        div { className: 'organization-unit__contacts' },
          for contact_id in @props.unit_data.contact_ids
            contact key: contact_id, contact_id: contact_id, hide: { unit: true }, className: 'list-item shadow'

      if isArray(@props.unit_data?.child_ids)
        div { className: 'organization-unit__sub-units' },
          for sub_unit_id in @props.unit_data.child_ids
            sub_unit { key: 'sub-unit-' + sub_unit_id, unit_id: sub_unit_id }


export default connect(mapStateToProps, mapDispatchToProps)(OrganizationUnitInfo)
