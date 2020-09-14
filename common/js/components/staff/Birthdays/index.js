import React from 'react';
import { connect } from 'react-redux';
import { isArray } from 'lodash';
import { Element as ScrollElement, scroller } from 'react-scroll';

import { dateByDayNumber } from '@lib/datetime';
import { getDayNumberByOffset, getBirthdayPeriodDates } from '@lib/birthdays';
import {
  scrolledToDate,
  extendBirthdayPeriodRight,
  extendBirthdayPeriodLeft
} from '@actions/birthday_period';

const div = React.createFactory('div');
const scroll_element = React.createFactory(ScrollElement);

import SomeoneWithButtons from '@components/staff/SomeoneWithButtons';
const someone = React.createFactory(SomeoneWithButtons);

const mapStateToProps = (state, ownProps) => {
  let scroll_to_date;
  let do_scroll = state.birthday_period.day_scroll_to != null;
  if (do_scroll) {
    const scroll_to_day_offset = state.birthday_period.day_scroll_to;
    const scroll_to_day_number = getDayNumberByOffset(
      state.birthday_period.key_date,
      scroll_to_day_offset
    );
    scroll_to_date = dateByDayNumber(scroll_to_day_number);
    if (do_scroll) {
      do_scroll = state.birthdays[scroll_to_date] != null;
    }
  }

  return {
    birthday_period: state.birthday_period,
    birthdays: state.birthdays,
    do_scroll,
    scroll_to: scroll_to_date
  };
};

const mapDispatchToProps = dispatch => ({
  scrolledToDate() {
    return dispatch(scrolledToDate());
  },

  stepForward() {
    return dispatch(extendBirthdayPeriodRight(7));
  },

  stepBackward() {
    return dispatch(extendBirthdayPeriodLeft(7));
  }
});

class Birthdays extends React.Component {
  componentDidUpdate(prevProps) {
    if (this.props.do_scroll) {
      scroller.scrollTo(`date-${this.props.scroll_to}`, {
        offset: -200,
        duration: 200,
        smooth: true,
        isDynamic: true,
        containerId: 'birthdays-scroller'
      });
      return this.props.scrolledToDate();
    }
  }

  stepForward() {
    return this.props.stepForward();
  }

  stepBackward() {
    return this.props.stepBackward();
  }

  render() {
    if (this.props.birthday_period.key_date == null) {
      return '';
    }

    const dates = getBirthdayPeriodDates(this.props.birthday_period);
    const prev_date_offset_left = dateByDayNumber(
      getDayNumberByOffset(
        this.props.birthday_period.key_date,
        this.props.birthday_period.prev_day_offset_left
      )
    );

    return div(
      { className: 'birthdays__scroller plug', id: 'birthdays-scroller' },
      div(
        { className: 'birthdays' },
        div({ className: 'birthdays__title' }, 'Дни рождения'),

        (() => {
          const result1 = [];
          for (let date of dates) {
            var day_obj = this.props.birthdays[date];

            if (day_obj) {
              result1.push(
                div(
                  { className: 'birthdays__date', key: date },
                  div(
                    { className: 'birthdays__date-head' },
                    scroll_element(
                      {
                        className: 'birthdays__date-title',
                        name: `date-${date}`
                      },
                      day_obj.date_formatted
                    ),
                    date === dates[0] || date === prev_date_offset_left
                      ? div(
                        {
                          className: 'birthdays__button-backward',
                          onClick: this.stepBackward.bind(this)
                        },
                        'Предыдущая неделя'
                      )
                      : undefined
                  ),

                  isArray(day_obj.results) && day_obj.results.length > 0
                    ? div(
                      { className: 'birthdays__results' },
                      (() => {
                        const result2 = [];
                        for (let result of day_obj.results) {
                          if (result.contact_id) {
                            result2.push(
                              someone({
                                key: result.contact_id,
                                contact_id: result.contact_id,
                                className: 'list-item shadow'
                              })
                            );
                          } else if (result.person_id) {
                            result2.push(
                              someone({
                                key: result.person_id,
                                employment_id: result.employ_ids[0],
                                hide: { birthday: true },
                                className: 'list-item shadow'
                              })
                            );
                          } else {
                            result2.push(undefined);
                          }
                        }
                        return result2;
                      })()
                    )
                    : undefined
                )
              );
            } else {
              result1.push(undefined);
            }
          }
          return result1;
        })(),

        div(
          {
            className: 'birthdays__button-forward',
            onClick: this.stepForward.bind(this)
          },
          'Смотреть дальше'
        )
      )
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(Birthdays);
