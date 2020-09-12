import React from 'react';
import PropTypes from 'prop-types';
import { loadSession } from '@actions/session';

const div = React.createFactory('div');

import Menu from '@components/common/Menu';
const menu = React.createFactory(Menu);

import Header from '@components/common/Header';
const header = React.createFactory(Header);

import WorkingArea from '@components/staff/WorkingArea';
const working_area = React.createFactory(WorkingArea);

class TopLayout extends React.Component {
  static fetchData(state) {
    return Promise.all([state.store.dispatch(loadSession())]);
  }

  render() {
    return div(
      { className: 'top-layout' },
      menu({}),

      div({ className: 'top-layout__header socket' }, header({})),
      div({ className: 'top-layout__working-area socket' }, working_area({}))
    );
  }
}

export default TopLayout;
