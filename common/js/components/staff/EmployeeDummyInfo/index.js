import React from 'react';

import { div, silhouette, iconedData } from '@components/factories';

import EmailIcon from '@icons/at-sign.svg';
import LunchIcon from '@icons/lunch.svg';
import LocationIcon from '@icons/location.svg';
import BirthdayIcon from '@icons/birthday.svg';

class EmployeeDummyInfo extends React.Component {
  onCloseButtonClick() {
    return this.props.unsetCurrentEmployee();
  }

  onUnitClick(e) {
    e.preventDefault();
    return this.props.onUnitClick(this.props.employment.unit_id);
  }

  render() {
    return div(
      { className: 'employee-info-scroller plug' },

      div(
        { className: 'employee-info employee-dummy-info' },

        div(
          { className: 'employee-dummy-info__head-info' },
          div({ className: 'employee-dummy-info__head' }),
          div({ className: 'employee-dummy-info__post-title' }),
          div({ className: 'employee-dummy-info__unit-title' })
        ),

        div(
          { className: 'employee-info__two-columns' },
          div(
            { className: 'employee-info__photo' },
            silhouette({ className: 'employee-dummy-info__avatar' })
          ),

          div(
            { className: 'employee-info__data' },
            div({ className: 'employee-dummy-info__phones' }),

            iconedData({
              className:
                'employee-dummy-info__iconed-data employee-dummy-info__location',
              icon: LocationIcon,
              align_icon: 'middle'
            }),

            iconedData({
              className:
                'employee-dummy-info__iconed-data employee-dummy-info__lunch-break',
              icon: LunchIcon,
              align_icon: 'middle'
            }),

            iconedData({
              className:
                'employee-dummy-info__iconed-data employee-dummy-info__birthday',
              icon: BirthdayIcon,
              align_icon: 'middle'
            })
          )
        )
      )
    );
  }
}

export default EmployeeDummyInfo;
