import React from 'react';
import { connect } from 'react-redux';

import { RESULTS_SOURCE_BIRTHDAY } from '@constants/search';

import {
  div,
  searchPanel,
  birthdayShortcutPanel,
  settingsPanel,
  toCallPanel,
  favoritesPanel,
  nodeInfo,
  organizationStructure,
  employeeInfo,
  contactInfo,
  employeeDummyInfo,
  searchResults,
  birthdays,
  toCallList,
  favoritesList
} from '@components/factories';

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
      div({ className: 'working-area__search-panel socket' }, searchPanel({})),

      div(
        { className: 'working-area__toolbar-panel' },
        div(
          { className: 'working-area__toolbar-panel-left' },
          birthdayShortcutPanel({ className: 'working-area__toolbar' })
        ),
        div(
          { className: 'working-area__toolbar-panel-right' },
          settingsPanel({ className: 'working-area__toolbar' }),
          favoritesPanel({ className: 'working-area__toolbar' }),
          toCallPanel({ className: 'working-area__toolbar' })
        )
      ),

      div(
        { className: 'working-area__results-panel' },
        div(
          {
            className: `working-area__block working-area__node-info socket block-index-${pile_hash['node-info']}`
          },
          nodeInfo({ className: 'plug' })
        ),
        div(
          {
            className: `working-area__block working-area__structure socket block-index-${pile_hash['structure']}`
          },
          organizationStructure({})
        ),
        div(
          {
            className: `working-area__block working-area__employee-info socket block-index-${pile_hash['employee-info']}`
          },
          this.props.employment_id
            ? employeeInfo({})
            : this.props.contact_id
              ? contactInfo({})
              : employeeDummyInfo({})
        ),
        div(
          {
            className: `working-area__block working-area__results socket block-index-${pile_hash['search-results']}`
          },
          this.props.results_source === RESULTS_SOURCE_BIRTHDAY ||
            this.props.results_type === 'birthday'
            ? birthdays({})
            : searchResults({})
        ),
        div(
          {
            className: `working-area__block working-area__to-call socket block-index-${pile_hash['to-call']}`
          },
          toCallList({})
        ),
        div(
          {
            className: `working-area__block working-area__favorites socket block-index-${pile_hash['favorites']}`
          },
          favoritesPanel({ className: 'plug' })
        )
      )
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(WorkingArea);
