import React from 'react'
import { connect } from 'react-redux'

div = React.createFactory('div')

import SearchPanel from '@components/staff/SearchPanel'
search_panel = React.createFactory(SearchPanel)

import BirthdayShortcutPanel from '@components/staff/BirthdayShortcutPanel'
birthday_panel = React.createFactory(BirthdayShortcutPanel)

import OrganizationUnitInfo from '@components/staff/OrganizationUnitInfo'
organization_unit_info = React.createFactory(OrganizationUnitInfo)

import OrganizationStructure from '@components/staff/OrganizationStructure'
organization_structure = React.createFactory(OrganizationStructure)

import EmployeeInfo from '@components/staff/EmployeeInfo'
employee_info = React.createFactory(EmployeeInfo)

import ContactInfo from '@components/staff/ContactInfo'
contact_info = React.createFactory(ContactInfo)

import EmployeeDummyInfo from '@components/staff/EmployeeDummyInfo'
dummy_info = React.createFactory(EmployeeDummyInfo)

import SearchResults from '@components/staff/SearchResults'
search_results = React.createFactory(SearchResults)

import Birthdays from '@components/staff/Birthdays'
birthdays = React.createFactory(Birthdays)


mapStateToProps = (state) ->
  pile: state.layout.pile
  employment_id: state.current.employment_id
  contact_id: state.current.contact_id
  results_type: state.search.results_type
  results_source: state.search.results_source

mapDispatchToProps = (dispatch) ->
  {}


class WorkingArea extends React.Component

  render: ->
    pile_hash = {}
    @props.pile.forEach (block, i) -> pile_hash[block] = i

    div { className: 'working-area plug' },
      div { className: 'working-area__search-panel socket' },
        search_panel {}
      div { className: 'working-area__birthday-panel socket' },
        birthday_panel {}
      div { className: 'working-area__results-panel' },
        div { className: "working-area__block working-area__unit-info socket block-index-#{pile_hash['unit-info']}" },
          organization_unit_info {}
        div { className: "working-area__block working-area__structure socket block-index-#{pile_hash['structure']}" },
          organization_structure {}
        div { className: "working-area__block working-area__employee-info socket block-index-#{pile_hash['employee-info']}" },
          if @props.employment_id?
            employee_info {}
          else if @props.contact_id?
            contact_info {}
          else
            dummy_info {}
        div { className: "working-area__block working-area__results socket block-index-#{pile_hash['search-results']}" },
          if @props.results_source == 'birthday' or @props.results_type == 'birthday'
            birthdays {}
          else
            search_results {}


export default connect(mapStateToProps, mapDispatchToProps)(WorkingArea)
