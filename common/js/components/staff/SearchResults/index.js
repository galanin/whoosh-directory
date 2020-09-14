import React from 'react';
import { connect } from 'react-redux';
import { isArray } from 'lodash';

const div = React.createFactory('div');

import SearchResultUnit from '@components/staff/SearchResultUnit';
const result_unit = React.createFactory(SearchResultUnit);

import SomeoneWithButtons from '@components/staff/SomeoneWithButtons';
const someone = React.createFactory(SomeoneWithButtons);

const mapStateToProps = (state, ownProps) => ({
  results: state.search.results,
  query: state.search.current_machine_query
});

const mapDispatchToProps = dispatch => ({});

class SearchResults extends React.Component {
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
            (() => {
              const result1 = [];
              for (let result of this.props.results) {
                if (result.unit_id) {
                  result1.push(
                    result_unit({
                      key: result.unit_id,
                      unit_id: result.unit_id,
                      className: 'list-item shadow'
                    })
                  );
                } else if (result.contact_id) {
                  result1.push(
                    someone({
                      key: result.contact_id,
                      contact_id: result.contact_id,
                      className: 'list-item shadow'
                    })
                  );
                } else if (result.person_id) {
                  if (result.employ_ids) {
                    result1.push(
                      someone({
                        key: result.person_id,
                        employment_id: result.employ_ids[0],
                        className: 'list-item shadow'
                      })
                    );
                  } else {
                    result1.push(undefined);
                  }
                } else {
                  result1.push(undefined);
                }
              }
              return result1;
            })()
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
