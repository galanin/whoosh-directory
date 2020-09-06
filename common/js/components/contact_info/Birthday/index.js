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

const div = React.createFactory('div');
const span = React.createFactory('span');
const svg = React.createFactory(SvgIcon);
const iconed_data = React.createFactory(IconedData);

import BirthdayIcon from '@icons/birthday.svg';

class Birthday extends React.Component {
  render() {
    if (this.props.birthday_formatted == null) { return ''; }

    const classes = {
      'contact-data-birthday' : true,
      'contact-data_highlighted' : this.props.highlighted,
      'contact-data-birthday_highlighted' : this.props.highlighted
    };
    classes[this.props.className] = true;

    return iconed_data({ className: classNames(classes), icon: BirthdayIcon, align_icon: 'middle' },
      div({ className: 'iconed-data__row iconed-data__row-title' },
        'День рождения'),
      div({ className: 'iconed-data__row iconed-data__row-data' },
        div({ className: 'iconed-data__row-data-value' },
          this.props.birthday_formatted)
      )
    );
  }
}


export default Birthday;
