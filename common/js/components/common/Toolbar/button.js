import React from 'react';
import PropTypes from 'prop-types';
import classNames from 'classnames';

import { a, div, svgIcon } from '@components/factories';

class ToolbarButton extends React.Component {
  render() {
    const class_name = classNames({
      'toolbar-button': true,
      'current-tool': this.props.current
    });

    return a(
      { className: class_name, href: this.props.href },
      svgIcon({ svg: this.props.svg }),
      div({ className: 'label' }, this.props.label)
    );
  }
}

export default ToolbarButton;
