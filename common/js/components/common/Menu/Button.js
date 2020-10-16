import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';

import { openMenu } from '@actions/menu';

const mapStateToProps = (state, ownProps) => ({});

const mapDispatchToProps = (dispatch, ownProps) => ({
  openMenu() {
    return dispatch(openMenu());
  }
});

class MenuButton extends React.Component {
  onClick(event) {
    event.preventDefault();
    return this.props.openMenu();
  }

  render() {
    return a(
      {
        className: 'menu-button-container',
        onClick: this.onClick.bind(this),
        href: '#'
      },
      span(
        { className: 'menu-button' },
        span({ className: 'menu-button-stripe menu-button-stripe-1' }),
        span({ className: 'menu-button-stripe menu-button-stripe-2' }),
        span({ className: 'menu-button-stripe menu-button-stripe-3' })
      )
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(MenuButton);
