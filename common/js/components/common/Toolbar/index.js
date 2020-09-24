import React from 'react';
import PropTypes from 'prop-types';

const div = React.createFactory('div');

import ToolbarButton from './button';
const toolbar_button = React.createFactory(ToolbarButton);

import Logo from './icons/logo-white.svg';
import Phonebook from './icons/phonebook.svg';

const buttons = {
  portal: {
    key: 'logo',
    href: 'http://portal',
    svg: Logo,
    label: 'Портал'
  },
  staff: {
    key: 'staff',
    href: 'http://staff',
    svg: Phonebook,
    label: 'Справочник сотрудников',
    current: true
  }
};

class Toolbar extends React.Component {
  render() {
    const current = this.props.current_tool;

    return (
      <div className='toolbar plug'>
        {buttons.map(key => {
          toolbar_button(key);
        })}
      </div>
    );
  }
}

export default Toolbar;
