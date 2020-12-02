import React from 'react';
import classNames from 'classnames';

import { div, svgIcon } from '@components/factories';

class IconedData extends React.Component {
  render() {
    const classes = {
      'iconed-data': true,
      'iconed-data_icon-align-top': this.props.align_icon === 'top',
      'iconed-data_icon-align-middle': this.props.align_icon === 'middle',
      'iconed-data_clickable': !!this.props.onClick
    };
    classes[this.props.className] = true;

    return div(
      { className: classNames(classes), onClick: this.props.onClick },
      svgIcon({ className: 'big-icon iconed-data__icon', svg: this.props.icon }),
      div(
        { className: 'iconed-data__container' },
        div({ className: 'iconed-data__data' }, this.props.children)
      )
    );
  }
}

export default IconedData;
