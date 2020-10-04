import React from 'react';
import { connect } from 'react-redux';
import { isArray } from 'lodash';
import classNames from 'classnames';

import { loadUnitInfo } from '@actions/units';
import { setCurrentEmploymentId } from '@actions/current';
import { popEmployeeInfo } from '@actions/layout';
import { currentTime, todayDate } from '@lib/datetime';

import SvgIcon from '@components/common/SvgIcon';
import ToCallIcon from '@icons/call.svg';
import StarIcon from '@icons/star.svg';

const div = React.createFactory('div');
const span = React.createFactory('span');
const img = React.createFactory('img');
const svg = React.createFactory(SvgIcon);

import CommonAvatar from '@components/staff/CommonAvatar';
const avatar = React.createFactory(CommonAvatar);

const mapStateToProps = (state, ownProps) => {
  const employment = state.employments[ownProps.employment_id];

  return {
    employment,
    person: employment && state.people[employment.person_id],
    node_id: employment?.parent_node_id,
    node: state.nodes.tree[employment?.parent_node_id],
    dept_id: employment?.dept_id,
    dept: state.nodes.tree[employment?.dept_id],
    current_employment_id: state.current.employment_id,
    is_to_call:
      state.to_call.unchecked_employment_index[ownProps.employment_id],
    is_favorite: state.favorites.employment_index[ownProps.employment_id],
    show_location: state.settings.search_results__show_location
  };
};

const mapDispatchToProps = (dispatch, ownProps) => ({
  setCurrentEmployee() {
    dispatch(setCurrentEmploymentId(ownProps.employment_id));
    return dispatch(popEmployeeInfo());
  }
});

class Employee extends React.Component {
  setCurrentTime() {
    return this.setState({
      current_time: currentTime(),
      current_date: todayDate()
    });
  }

  isOnLunchNow() {
    if (
      this.props.employment?.lunch_begin &&
      this.props.employment?.lunch_end &&
      this.state?.current_time
    ) {
      return (
        this.props.employment.lunch_begin <= this.state.current_time &&
        this.state.current_time < this.props.employment.lunch_end
      );
    }
  }

  isBirthday() {
    if (this.props.person?.birthday && this.state?.current_date) {
      return this.props.person.birthday === this.state.current_date;
    }
  }

  componentDidMount() {
    this.setCurrentTime();
    return (this.interval = setInterval(() => this.setCurrentTime(), 30000));
  }

  componentWillUnmount() {
    return clearInterval(this.interval);
  }

  onContactClick() {
    return this.props.setCurrentEmployee();
  }

  birthday() {
    if (!this.props.hide?.birthday) {
      if (this.isBirthday()) {
        return div(
          { className: 'employee__status employee__birthday' },
          'День рождения'
        );
      }
    }
  }

  vacationOrLunch() {
    if (this.props.employment.on_vacation) {
      return div(
        { className: 'employee__status employee__on-vacation' },
        'В отпуске'
      );
    } else {
      if (this.isOnLunchNow()) {
        return div(
          { className: 'employee__status employee__on-lunch' },
          'Обеденный перерыв'
        );
      }
    }
  }

  photoOrAvatar() {
    const { photo } = this.props.person;

    if (photo.thumb45.url || photo.thumb60.url) {
      if (photo.thumb45.url) {
        img({
          src: process.env.PHOTO_BASE_URL + photo.thumb45.url,
          className: 'employee__thumb45'
        });
      }
      if (photo.thumb60.url) {
        return img({
          src: process.env.PHOTO_BASE_URL + photo.thumb60.url,
          className: 'employee__thumb60'
        });
      }
    } else {
      return avatar({
        className: 'employee__avatar',
        gender: this.props.person.gender,
        post_code: this.props.employment.post_code
      });
    }
  }

  render() {
    if (!this.props.employment || !this.props.person) {
      return '';
    }

    const class_names = {
      employee: true,
      employee_highlighted:
        this.props.employment.id === this.props.current_employment_id
    };
    class_names[this.props.className] = true;

    return div(
      {
        className: classNames(class_names),
        onClick: this.onContactClick.bind(this)
      },
      div({ className: 'employee__photo' }, this.photoOrAvatar()),

      div(
        { className: 'employee__info' },
        div(
          { className: 'employee__name' },
          span(
            { className: 'employee__last-name' },
            this.props.person.last_name
          ),
          span(
            { className: 'employee__first-name' },
            this.props.person.first_name
          ),
          span(
            { className: 'employee__middle-name' },
            this.props.person.middle_name
          ),

          this.props.is_to_call
            ? svg({
              className: 'small-icon employee__to-call',
              svg: ToCallIcon
            })
            : undefined,

          this.props.is_favorite
            ? svg({ className: 'small-icon employee__favorite', svg: StarIcon })
            : undefined
        ),

        !this.props.hide?.post
          ? div(
            { className: 'employee__post_title' },
            this.props.employment.post_title
          )
          : undefined,

        !this.props.hide?.unit
          ? div(
            { className: 'employee__organization_unit_title' },
            this.props.dept && this.props.dept_id !== this.props.node_id
              ? this.props.dept.t
              : this.props.node?.t
          )
          : undefined,

        this.props.show_location
          ? div(
            { className: 'employee__location' },
            this.props.employment.building
              ? span(
                { className: 'employee__location-building' },
                span(
                  { className: 'employee__location-building-label' },
                  'Корпус '
                ),
                span(
                  { className: 'employee__location-building-number' },
                  this.props.employment.building
                )
              )
              : undefined,
            this.props.employment.office
              ? span(
                { className: 'employee__location-office' },
                span(
                  { className: 'employee__location-office-label' },
                  this.props.employment.building ? ', кабинет ' : 'Кабинет '
                ),
                span(
                  { className: 'employee__location-office-number' },
                  this.props.employment.office
                )
              )
              : undefined
          )
          : undefined
      ),

      isArray(this.props.employment.format_phones) &&
        this.props.employment.format_phones.length > 0
        ? div(
          { className: 'employee__phones' },
          this.props.employment.format_phones
            .slice(0, 3)
            .map(phone =>
              div({ className: 'employee__phone', key: phone[1] }, phone[1])
            )
        )
        : undefined,

      div(
        { className: 'employee__status-container' },
        this.vacationOrLunch(),
        this.birthday()
      )
    );
  }
}

const ConnectedEmployee = connect(
  mapStateToProps,
  mapDispatchToProps
)(Employee);
const employee = React.createFactory(ConnectedEmployee);

export default ConnectedEmployee;
