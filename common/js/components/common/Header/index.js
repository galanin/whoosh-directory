import React from 'react';

import { a, div } from '@components/factories';

class Header extends React.Component {
  onClick(event) {
    return event.preventDefault();
  }

  render() {
    return div(
      { className: 'header plug' },
      a(
        {
          className: 'header-title',
          href: '/',
          onClick: this.onClick.bind(this)
        },
        'Справочник сотрудников'
      )
    );
  }
}

export default Header;
