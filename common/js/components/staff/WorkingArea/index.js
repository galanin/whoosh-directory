/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import React from 'react';
import { connect } from 'react-redux';

import { RESULTS_SOURCE_BIRTHDAY } from '@constants/search';

const div = React.createFactory('div');

import SearchPanel from '@components/staff/SearchPanel';
const search_panel = React.createFactory(SearchPanel);

import BirthdayShortcutPanel from '@components/staff/BirthdayShortcutPanel';
const birthday_panel = React.createFactory(BirthdayShortcutPanel);

import SettingsPanel from '@components/staff/SettingsPanel';
const settings_panel = React.createFactory(SettingsPanel);

import ToCallPanel from '@components/staff/ToCallPanel';
const to_call_panel = React.createFactory(ToCallPanel);

import FavoritesPanel from '@components/staff/FavoritesPanel';
const favorites_panel = React.createFactory(FavoritesPanel);

import NodeInfo from '@components/staff/NodeInfo';
const node_info = React.createFactory(NodeInfo);

import OrganizationStructure from '@components/staff/OrganizationStructure';
const organization_structure = React.createFactory(OrganizationStructure);

import EmployeeInfo from '@components/staff/EmployeeInfo';
const employee_info = React.createFactory(EmployeeInfo);

import ContactInfo from '@components/staff/ContactInfo';
const contact_info = React.createFactory(ContactInfo);

import EmployeeDummyInfo from '@components/staff/EmployeeDummyInfo';
const dummy_info = React.createFactory(EmployeeDummyInfo);

import SearchResults from '@components/staff/SearchResults';
const search_results = React.createFactory(SearchResults);

import Birthdays from '@components/staff/Birthdays';
const birthdays = React.createFactory(Birthdays);

import ToCallList from '@components/staff/ToCallList';
const to_call = React.createFactory(ToCallList);

import FavoritesList from '@components/staff/FavoritesList';
const favorites = React.createFactory(FavoritesList);

const mapStateToProps = state => ({
  pile: state.layout.pile,
  employment_id: state.current.employment_id,
  contact_id: state.current.contact_id,
  results_type: state.search.results_type,
  results_source: state.search.results_source
});

const mapDispatchToProps = dispatch => ({});

class WorkingArea extends React.Component {
  render() {
    const pile_hash = {};
    this.props.pile.forEach((block, i) => (pile_hash[block] = i));

    return div(
      { className: 'working-area plug' },
      div({ className: 'working-area__search-panel socket' }, search_panel({})),

      div(
        { className: 'working-area__toolbar-panel' },
        div(
          { className: 'working-area__toolbar-panel-left' },
          birthday_panel({ className: 'working-area__toolbar' })
        ),
        div(
          { className: 'working-area__toolbar-panel-right' },
          settings_panel({ className: 'working-area__toolbar' }),
          favorites_panel({ className: 'working-area__toolbar' }),
          to_call_panel({ className: 'working-area__toolbar' })
        )
      ),

      div(
        { className: 'working-area__results-panel' },
        div(
          {
            className: `working-area__block working-area__node-info socket block-index-${pile_hash['node-info']}`
          },
          node_info({ className: 'plug' })
        ),
        div(
          {
            className: `working-area__block working-area__structure socket block-index-${pile_hash['structure']}`
          },
          organization_structure({})
        ),
        div(
          {
            className: `working-area__block working-area__employee-info socket block-index-${pile_hash['employee-info']}`
          },
          this.props.employment_id != null
            ? employee_info({})
            : this.props.contact_id != null
              ? contact_info({})
              : dummy_info({})
        ),
        div(
          {
            className: `working-area__block working-area__results socket block-index-${pile_hash['search-results']}`
          },
          this.props.results_source === RESULTS_SOURCE_BIRTHDAY ||
            this.props.results_type === 'birthday'
            ? birthdays({})
            : search_results({})
        ),
        div(
          {
            className: `working-area__block working-area__to-call socket block-index-${pile_hash['to-call']}`
          },
          to_call({})
        ),
        div(
          {
            className: `working-area__block working-area__favorites socket block-index-${pile_hash['favorites']}`
          },
          favorites({ className: 'plug' })
        )
      )
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(WorkingArea);
