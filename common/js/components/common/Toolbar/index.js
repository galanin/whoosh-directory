/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS205: Consider reworking code to avoid use of IIFEs
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import React from 'react';
import PropTypes from 'prop-types';

const div = React.createFactory('div');

import ToolbarButton from './button';
const toolbar_button = React.createFactory(ToolbarButton);

import Logo from './icons/logo-white.svg';
import Phonebook from './icons/phonebook.svg';


const buttons = {
  portal: {
    key:  'logo',
    href: 'http://portal',
    svg:  Logo,
    label: 'Портал'
  },
  staff: {
    key:  'staff',
    href: 'http://staff',
    svg:  Phonebook,
    label: 'Справочник сотрудников',
    current: true
  }
};


class Toolbar extends React.Component {

  render() {
    const current = this.props.current_tool;

    return div({ className: 'toolbar plug' },
      (() => {
        const result = [];
        for (let key in buttons) {
          const button = buttons[key];
          result.push(toolbar_button(button));
        }
        return result;
      })()
    );
  }
}


export default Toolbar;
