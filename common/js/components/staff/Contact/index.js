import React from 'react';
import { connect } from 'react-redux';
import { isArray } from 'lodash';
import classNames from 'classnames';

import { div, span, img, svgIcon, commonAvatar } from '@components/factories';

import { loadUnitInfo } from '@actions/units';
import { setCurrentContactId } from '@actions/current';
import { popEmployeeInfo } from '@actions/layout';
import { currentTime, todayDate } from '@lib/datetime';

import ToCallIcon from '@icons/call.svg';
import StarIcon from '@icons/star.svg';

const mapStateToProps = (state, ownProps) => {
  const contact = state.contacts[ownProps.contact_id];
  return {
    contact,
    node: state.nodes.tree[contact?.node_id],
    current_contact_id: state.current.contact_id,
    is_to_call: state.to_call.unchecked_contact_index[ownProps.contact_id],
    is_favorite: state.favorites.contact_index[ownProps.contact_id],
    show_location: state.settings.search_results__show_location
  };
};

const mapDispatchToProps = (dispatch, ownProps) => ({
  setCurrentContact() {
    dispatch(setCurrentContactId(ownProps.contact_id));
    return dispatch(popEmployeeInfo());
  }
});

class Contact extends React.Component {
  isOnLunchNow() {
    if (
      this.props.contact?.lunch_begin &&
      this.props.contact?.lunch_end &&
      this.state?.current_time
    ) {
      return (
        this.props.contact.lunch_begin <= this.state.current_time &&
        this.state.current_time < this.props.contact.lunch_end
      );
    }
  }

  isBirthday() {
    if (this.props.person?.birthday && this.state?.current_date) {
      return this.props.person.birthday === this.state.current_date;
    }
  }

  setCurrentTime() {
    return this.setState({
      current_time: currentTime(),
      current_date: todayDate()
    });
  }

  componentDidMount() {
    this.setCurrentTime();
    return (this.interval = setInterval(() => this.setCurrentTime(), 30000));
  }

  componentWillUnmount() {
    return clearInterval(this.interval);
  }

  onContactClick() {
    return this.props.setCurrentContact();
  }

  photoOrAvatar() {
    if (this.photo.thumb45.url || this.photo.thumb60.url) {
      if (this.photo.thumb45.url) {
        img({
          src: process.env.PHOTO_BASE_URL + this.photo.thumb45.url,
          className: 'employee__thumb45'
        });
      }
      if (this.photo.thumb60.url) {
        return img({
          src: process.env.PHOTO_BASE_URL + this.photo.thumb60.url,
          className: 'employee__thumb60'
        });
      }
    } else {
      return commonAvatar({
        className: 'employee__avatar',
        gender: this.props.contact.gender,
        post_code: this.props.contact.post_code
      });
    }
  }

  vacationOrLunch() {
    if (this.props.contact.on_vacation) {
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

  fullName() {
    if (this.props.contact.last_name) {
      return [
        span(
          { className: 'employee__last-name' },
          this.props.contact.last_name
        ),
        span(
          { className: 'employee__first-name' },
          this.props.contact.first_name
        ),
        span(
          { className: 'employee__middle-name' },
          this.props.contact.middle_name
        )
      ];
    } else if (this.props.contact.function_title) {
      return this.props.contact.function_title;
    } else if (this.props.contact.location_title) {
      return this.props.contact.location_title;
    }
  }

  organizationTitle() {
    if (!this.props.hide?.unit) {
      if (this.props.node) {
        return div(
          { className: 'employee__organization_unit_title' },
          this.props.node.t
        );
      }
    }
  }

  office() {
    if (this.props.contact.office) {
      span(
        { className: 'employee__location-office' },
        span(
          { className: 'employee__location-office-label' },
          this.props.contact.building ? ', кабинет ' : 'Кабинет '
        ),
        span(
          { className: 'employee__location-office-number' },
          this.props.contact.office
        )
      );
    }
  }

  building() {
    if (this.props.contact.building) {
      span(
        { className: 'employee__location-building' },
        span({ className: 'employee__location-building-label' }, 'Корпус '),
        span(
          { className: 'employee__location-building-number' },
          this.props.contact.building
        )
      );
    }
  }

  location() {
    if (this.props.show_location) {
      div({ className: 'employee__location' }, this.building(), this.office());
    }
  }

  employeePhone() {
    if (
      isArray(this.props.contact.format_phones) &&
      this.props.contact.format_phones.length > 0
    ) {
      div(
        { className: 'employee__phones' },

        this.props.contact.format_phones
          .slice(0, 3)
          .map(phone =>
            div({ className: 'employee__phone', key: phone[1] }, phone[1])
          )
      );
    }
  }

  birthday() {
    if (this.isBirthday()) {
      div(
        { className: 'employee__status employee__birthday' },
        'День рождения'
      );
    }
  }

  postTitle() {
    if (this.props.contact.post_title) {
      div({ className: 'employee__post_title' }, this.props.contact.post_title);
    }
  }

  render() {
    if (!this.props.contact) {
      return '';
    }

    const { photo } = this.props.contact;

    const class_names = {
      employee: true,
      contact: true,
      employee_highlighted:
        this.props.contact.id === this.props.current_contact_id,
      contact_highlighted:
        this.props.contact.id === this.props.current_contact_id
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

          this.fullName(),

          this.props.is_to_call &&
            svgIcon({
              className: 'small-icon employee__to-call',
              svg: ToCallIcon
            }),

          this.props.is_favorite &&
            svgIcon({
              className: 'small-icon employee__favorite',
              svg: StarIcon
            })
        ),
        this.postTitle(),

        this.organizationTitle(),

        this.location()
      ),
      this.employeePhone(),
      div(
        { className: 'employee__status-container' },

        this.vacationOrLunch(),

        this.birthday()
      )
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(Contact);
