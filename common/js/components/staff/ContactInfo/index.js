import React from 'react';
import { connect } from 'react-redux';

import {
  div,
  span,
  a,
  img,
  svgIcon,
  silhouette,
  someoneButtons,
  phones,
  email,
  officeLocation,
  lunchBreak,
  birthday,
  iconedData
} from '@components/factories';

import { setCurrentContactId } from '@actions/current';
import { sinkEmployeeInfo, popNodeInfo, popStructure } from '@actions/layout';
import { goToNodeInStructure } from '@actions/nodes';
import { currentTime, todayDate } from '@lib/datetime';

import CloseButton from '@icons/close_button.svg';
import VacationIcon from '@icons/vacation.svg';

const mapStateToProps = function(state, ownProps) {
  const { contact_id } = state.current;
  const contact = state.contacts[contact_id];

  return {
    contact_id,
    contact,
    node_id: contact?.node_id,
    node: state.nodes.tree[contact?.node_id]
  };
};

const mapDispatchToProps = dispatch => ({
  unsetCurrentContact() {
    dispatch(sinkEmployeeInfo());
    return dispatch(setCurrentContactId(null));
  },

  goToNode(node_id) {
    dispatch(goToNodeInStructure(node_id));
    dispatch(popNodeInfo());
    return dispatch(popStructure());
  }
});

class EmployeeInfo extends React.Component {
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

  componentDidMount() {
    this.setCurrentTime();
    return (this.interval = setInterval(() => this.setCurrentTime(), 10000));
  }

  componentWillUnmount() {
    return clearInterval(this.interval);
  }

  setCurrentTime() {
    return this.setState({
      current_time: currentTime(),
      current_date: todayDate()
    });
  }

  onCloseButtonClick() {
    return this.props.unsetCurrentContact();
  }

  onNodeClick(e) {
    e.preventDefault();
    return this.props.goToNode(this.props.node_id);
  }

  fullName() {
    if (this.props.contact.last_name) {
      return (
        this.props.contact.last_name +
        ' ' +
        this.props.contact.first_name +
        ' ' +
        this.props.contact.middle_name
      );
    } else if (this.props.contact.function_title) {
      return this.props.contact.function_title;
    } else if (this.props.contact.location_title) {
      return this.props.contact.location_title;
    }
  }

  largePhotoOrSilhouette() {
    if (this.props.contact.photo.large.url) {
      return img({
        src: process.env.PHOTO_BASE_URL + this.props.contact.photo.large.url,
        className: 'employee-info__photo-large'
      });
    } else if (this.props.contact.gender) {
      return silhouette({
        className: 'employee-info__avatar',
        gender: this.props.contact.gender
      });
    }
  }

  photoOrSilhouette() {
    if (this.props.contact.photo.large.url) {
      return div(
        { className: 'employee-info__photo' },
        this.largePhotoOrSilhouette()
      );
    } else if (this.props.contact.gender) {
      return silhouette({
        className: 'employee-info__avatar',
        gender: this.props.contact.gender
      });
    }
  }

  vacationIcon() {
    if (this.props.contact.on_vacation) {
      return iconedData(
        {
          className: 'employee-info__iconed-data employee-info__vacation',
          icon: VacationIcon,
          align_icon: 'middle'
        },
        'В отпуске'
      );
    }
  }

  unitTitle() {
    if (this.props.node) {
      return a(
        {
          className: 'employee-info__unit_title',
          onClick: this.onNodeClick.bind(this),
          href: '/'
        },
        span({ className: 'employee-info__unit-long-title' }, this.props.node.t)
      );
    }
  }

  render() {
    return div(
      { className: 'employee-info-container soft-shadow plug' },
      div(
        {
          className: 'employee-info__close-button',
          onClick: this.onCloseButtonClick.bind(this)
        },
        svgIcon({
          className: 'employee-info__close-button-cross',
          svg: CloseButton
        })
      ),

      div(
        { className: 'employee-info-scroller' },

        this.props.contact
          && div(
            { className: 'employee-info contact-info' },

            div(
              { className: 'employee-info__head contact-info__head' },

              div(
                { className: 'employee-info__name contact-info__name' },
                this.fullName()
              )
            ),

            div(
              { className: 'employee-info__post-title' },
              this.props.contact.post_title
            ),

            this.unitTitle(),

            div(
              { className: 'employee-info__two-columns' },

              this.photoOrSilhouette(),

              div(
                { className: 'employee-info__data' },

                someoneButtons({ contact_id: this.props.contact_id }),

                phones({
                  format_phones: this.props.contact.format_phones,
                  className:
                      'employee-info__iconed-data employee-info__phones'
                }),

                email({
                  email: this.props.contact.email,
                  className: 'employee-info__iconed-data employee-info__email'
                }),

                officeLocation({
                  building: this.props.contact.building,
                  office: this.props.contact.office,
                  className:
                      'employee-info__iconed-data employee-info__location'
                }),

                lunchBreak({
                  lunch_begin: this.props.contact.lunch_begin,
                  lunch_end: this.props.contact.lunch_end,
                  highlighted:
                      !this.props.contact.on_vacation && this.isOnLunchNow(),
                  className:
                      'employee-info__iconed-data employee-info__lunch-break'
                }),

                birthday({
                  birthday_formatted: this.props.contact.birthday_formatted,
                  className:
                      'employee-info__iconed-data employee-info__birthday'
                }),

                this.vacationIcon()
              )
            )
          )
      )
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(EmployeeInfo);
