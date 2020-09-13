/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import React from 'react';
import classNames from 'classnames';
import SvgIcon from '@components/common/SvgIcon';
import IconedData from '@components/contact_info/IconedData';

import EmailIcon from '@icons/at-sign.svg';

class Email extends React.Component {
  render() {
    if (this.props.email == null) {
      return '';
    }

    const classes = { 'contact-data-email': true };
    classes[this.props.className] = true;

    return (
      <IconedData
        className={classNames(classes)}
        icon={EmailIcon}
        align_icon="middle"
      >
        <div className="iconed-data__row iconed-data__row-title">E-mail</div>
        <div className="iconed-data__row iconed-data__row-data">
          <a
            className="iconed-data__row-data-value iconed-data__email-link"
            href={'mailto:' + this.props.email}
          >
            {this.props.email}
          </a>
        </div>
      </IconedData>
    );
  }
}

export default Email;
