/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import React from 'react';
import PropTypes from 'prop-types';

const div = React.createFactory('div');
const a = React.createFactory('a');

class Header extends React.Component {

  onClick(event) {
    return event.preventDefault();
  }


  render() {
    return div({ className: 'header plug' },
      a({ className: 'header-title', href: '/', onClick: this.onClick.bind(this) },
        'Справочник сотрудников')
    );
  }
}

export default Header;
