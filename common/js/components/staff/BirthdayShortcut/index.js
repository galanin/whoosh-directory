import React from 'react';
import classNames from 'classnames';
import { connect } from 'react-redux';

import { RESULTS_SOURCE_BIRTHDAY } from '@constants/search';

import { setBirthdayPeriodByShortcut } from '@actions/birthday_period';
import { setResultsSource } from '@actions/search';
import { popSearchResults } from '@actions/layout';

const span = React.createFactory('span');

const mapStateToProps = (state, ownProps) => ({});

const mapDispatchToProps = (dispatch, ownProps) => ({
  setBirthdayPeriodByShortcut() {
    dispatch(setBirthdayPeriodByShortcut(ownProps.shortcut));
    dispatch(setResultsSource(RESULTS_SOURCE_BIRTHDAY));
    return dispatch(popSearchResults());
  }
});

class BirthdayShortcut extends React.Component {
  onClick() {
    return this.props.setBirthdayPeriodByShortcut();
  }

  render() {
    const classes = { 'birthday-shortcut': true };
    classes[this.props.className] = true;

    return span(
      { className: classNames(classes), onClick: this.onClick.bind(this) },
      this.props.children
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(BirthdayShortcut);
