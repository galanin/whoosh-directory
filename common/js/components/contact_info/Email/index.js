import React from 'react';
import classNames from 'classnames';

import { a, div, iconedData } from '@components/factories';

import EmailIcon from '@icons/at-sign.svg';

class Email extends React.Component {
  render() {
    if (!this.props.email) {
      return '';
    }

    const classes = { 'contact-data-email': true };
    classes[this.props.className] = true;

    return iconedData(
      { className: classNames(classes), icon: EmailIcon, align_icon: 'middle' },
      div({ className: 'iconed-data__row iconed-data__row-title' }, 'E-mail'),
      div(
        { className: 'iconed-data__row iconed-data__row-data' },
        a(
          {
            className: 'iconed-data__row-data-value iconed-data__email-link',
            href: 'mailto:' + this.props.email
          },
          this.props.email
        )
      )
    );
  }
}

export default Email;
