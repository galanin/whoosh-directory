import React from 'react';

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
