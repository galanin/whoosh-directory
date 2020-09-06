/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import React from 'react';
import { connect } from 'react-redux';
import classNames from 'classnames';
import { isArray } from 'lodash';

import { RESULTS_SOURCE_QUERY } from '@constants/search';

import { setQuery } from '@actions/search';
import { setResultsSource } from '@actions/search';
import { popSearchResults } from '@actions/layout';

const div = React.createFactory('div');
const span = React.createFactory('span');


const mapStateToProps = (state, ownProps) => ({});


const mapDispatchToProps = (dispatch, ownProps) => ({
  onClick(phone) {
    dispatch(setQuery(new String(phone)));
    dispatch(setResultsSource(RESULTS_SOURCE_QUERY));
    return dispatch(popSearchResults());
  }
});


class Phones extends React.Component {
  onClick(phone) {
    return this.props.onClick(phone[0]);
  }


  render() {
    if (!isArray(this.props.format_phones) || !(this.props.format_phones.length > 0)) { return ''; }

    const classes =
      {'contact-data-phones' : true};
    classes[this.props.className] = true;

    return div({ className: classNames(classes) },
      div({ className: 'contact-data-phones__title' },
        this.props.format_phones.length === 1 ?
          'Телефон'
          :
          'Телефоны'
      ),

      div({ className: 'contact-data-phones__phones' },
        Array.from(this.props.format_phones).map((phone) =>
          div({ className: 'contact-data-phones__phone', key: phone, onClick: this.onClick.bind(this, phone) },
            span({ className: 'contact-data-phones__phone-label' },
              phone[2] + ' '),
            span({ className: 'contact-data-phones__phone-number' },
              phone[1])))));
  }
}


export default connect(mapStateToProps, mapDispatchToProps)(Phones);
