import React from 'react';
import SvgIcon from '@components/common/SvgIcon';
import Silhouette from '@components/contact_info/CommonSilhouette';
import IconedData from '@components/contact_info/IconedData';

const div = React.createFactory('div');
const span = React.createFactory('span');
const svg = React.createFactory(SvgIcon);
const silhouette = React.createFactory(Silhouette);
const iconed_data = React.createFactory(IconedData);

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

            iconed_data({
              className:
                'employee-dummy-info__iconed-data employee-dummy-info__location',
              icon: LocationIcon,
              align_icon: 'middle'
            }),

            iconed_data({
              className:
                'employee-dummy-info__iconed-data employee-dummy-info__lunch-break',
              icon: LunchIcon,
              align_icon: 'middle'
            }),

            iconed_data({
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
