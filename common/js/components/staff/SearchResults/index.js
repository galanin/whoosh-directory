import React from 'react';
import { connect } from 'react-redux';
import { isArray } from 'lodash';

import {
  div,
  searchResultUnit,
  someoneWithButtons
} from '@components/factories';

const mapStateToProps = (state, ownProps) => ({
  results: state.search.results,
  query: state.search.current_machine_query
});

const mapDispatchToProps = dispatch => ({});

class SearchResults extends React.Component {
  searchResults() {
    return Array.from(this.props.results).map(result => {
      if (result.unit_id) {
        return searchResultUnit({
          key: result.unit_id,
          unit_id: result.unit_id,
          className: 'list-item shadow'
        });
      } else if (result.contact_id) {
        return someoneWithButtons({
          key: result.contact_id,
          contact_id: result.contact_id,
          className: 'list-item shadow'
        });
      } else if (result.person_id) {
        if (result.employ_ids) {
          return someoneWithButtons({
            key: result.person_id,
            employment_id: result.employ_ids[0],
            className: 'list-item shadow'
          });
        }
      }
    });
  }

  render() {
    return div(
      { className: 'search-results__scroller plug' },
      div(
        { className: 'search-results' },
        div(
          { className: 'search-results__head' },
          div({ className: 'search-results__title' }, 'Результаты поиска')
        ),

        isArray(this.props.results) && this.props.results.length > 0
          ? div(
            { className: 'search-results__results' },
            this.searchResults()
          )
          : div(
            { className: 'search-results__no-results' },
            !this.props.query || this.props.query === ''
              ? 'Введите ваш запрос в поисковую строку выше'
              : 'Ничего не найдено'
          )
      )
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(SearchResults);