import React from 'react';
import classNames from 'classnames';

import { div, span, iconedData } from '@components/factories';

import LunchIcon from '@icons/lunch.svg';

class LunchBreak extends React.Component {
  render() {
    if (!this.props.lunch_begin || !this.props.lunch_end) {
      return '';
    }

    const classes = {
      'contact-data-lunch-break': true,
      'contact-data_highlighted': this.props.highlighted,
      'contact-data-lunch-break_highlighted': this.props.highlighted
    };
    classes[this.props.className] = true;

    return iconedData(
      { className: classNames(classes), icon: LunchIcon, align_icon: 'middle' },
      div(
        { className: 'iconed-data__row iconed-data__row-title' },
        'Обеденный перерыв'
      ),
      div(
        { className: 'iconed-data__row iconed-data__row-data' },
        div(
          { className: 'iconed-data__row-data-value' },
          span(
            { className: 'employee-info__lunch-begin' },
            this.props.lunch_begin
          ),
          span({ className: 'employee-info__lunch-separator' }, '—'),
          span({ className: 'employee-info__lunch-end' }, this.props.lunch_end)
        )
      )
    );
  }
}

export default LunchBreak;
