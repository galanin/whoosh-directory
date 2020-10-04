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

    return (
      <div className="working-area plug">
        <div className="working-area__search-panel socket">
          <SearchPanel />
        </div>
        <div className="working-area__toolbar-panel">
          <div className="working-area__toolbar-panel-left">
            <BirthdayShortcutPanel className="working-area__toolbar" />
          </div>
          <div className="working-area__toolbar-panel-right">
            <SettingsPanel className="working-area__toolbar" />
            <FavoritesPanel className="working-area__toolbar" />
            <ToCallPanel className="working-area__toolbar" />
          </div>

        </div>

        <div className="working-area__results-panel">
          <div
            className={`working-area__block working-area__node-info socket block-index-${pile_hash['node-info']}`}
          >
            <NodeInfo className="plug" />
          </div>

          <div
            className={`working-area__block working-area__structure socket block-index-${pile_hash['structure']}`}
          >
            <OrganizationStructure />
          </div>

          <div
            className={`working-area__block working-area__employee-info socket block-index-${pile_hash['employee-info']}`}
          >
            {this.props.employment_id ? (
              <EmployeeInfo />
            ) : this.props.contact_id ? (
              <ContactInfo />
            ) : (
              <EmployeeDummyInfo />
            )}
          </div>

          <div
            className={`working-area__block working-area__results socket block-index-${pile_hash['search-results']}`}
          >
            {this.props.results_source === RESULTS_SOURCE_BIRTHDAY ||
            this.props.results_type === 'birthday' ? (
                <Birthdays />
              ) : (
                <SearchResults />
              )}
          </div>

          <div
            className={`working-area__block working-area__to-call socket block-index-${pile_hash['to-call']}`}
          >
            <ToCallList />
          </div>

          <div
            className={`working-area__block working-area__favorites socket block-index-${pile_hash['favorites']}`}
          >
            <FavoritesList className="plug" />
          </div>
        </div>
      </div>
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(WorkingArea);
