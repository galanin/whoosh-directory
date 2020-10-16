import React from 'react';
import { connect } from 'react-redux';

import { RESULTS_SOURCE_BIRTHDAY } from '@constants/search';

import SearchPanel from '@components/staff/SearchPanel';
import BirthdayShortcutPanel from '@components/staff/BirthdayShortcutPanel';
import SettingsPanel from '@components/staff/SettingsPanel';
import ToCallPanel from '@components/staff/ToCallPanel';
import FavoritesPanel from '@components/staff/FavoritesPanel';
import NodeInfo from '@components/staff/NodeInfo';
import OrganizationStructure from '@components/staff/OrganizationStructure';
import EmployeeInfo from '@components/staff/EmployeeInfo';
import ContactInfo from '@components/staff/ContactInfo';
import EmployeeDummyInfo from '@components/staff/EmployeeDummyInfo';
import SearchResults from '@components/staff/SearchResults';
import Birthdays from '@components/staff/Birthdays';
import ToCallList from '@components/staff/ToCallList';
import FavoritesList from '@components/staff/FavoritesList';

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
          this.props.employment_id
            ? employee_info({})
            : this.props.contact_id
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
