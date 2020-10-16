import React from 'react';
import classNames from 'classnames';

import { div, iconedData } from '@components/factories';

import BirthdayIcon from '@icons/birthday.svg';

class Birthday extends React.Component {
  render() {
    if (!this.props.birthday_formatted) {
      return '';
    }

    const classes = {
      'contact-data-birthday': true,
      'contact-data_highlighted': this.props.highlighted,
      'contact-data-birthday_highlighted': this.props.highlighted
    };
    classes[this.props.className] = true;

    return iconedData(
      {
        className: classNames(classes),
        icon: BirthdayIcon,
        align_icon: 'middle'
      },
      div(
        { className: 'iconed-data__row iconed-data__row-title' },
        'День рождения'
      ),
      div(
        { className: 'iconed-data__row iconed-data__row-data' },
        div(
          { className: 'iconed-data__row-data-value' },
          this.props.birthday_formatted
        )
      )
    );
  }
}

export default Birthday;
