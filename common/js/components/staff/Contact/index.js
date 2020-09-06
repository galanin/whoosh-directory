/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * DS205: Consider reworking code to avoid use of IIFEs
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import React from 'react';
import { connect } from 'react-redux';
import { isArray } from 'lodash';
import classNames from 'classnames';

import { loadUnitInfo } from '@actions/units';
import { setCurrentContactId } from '@actions/current';
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


const mapStateToProps = function(state, ownProps) {
  const contact = state.contacts[ownProps.contact_id];
  return {
    contact,
    node: state.nodes.tree[contact != null ? contact.node_id : undefined],
    current_contact_id: state.current.contact_id,
    is_to_call  : (state.to_call.unchecked_contact_index[ownProps.contact_id] != null),
    is_favorite : (state.favorites.contact_index[ownProps.contact_id] != null),
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
    if (((this.props.contact != null ? this.props.contact.lunch_begin : undefined) != null) && ((this.props.contact != null ? this.props.contact.lunch_end : undefined) != null) && ((this.state != null ? this.state.current_time : undefined) != null)) {
      return this.props.contact.lunch_begin <= this.state.current_time && this.state.current_time < this.props.contact.lunch_end;
    }
  }


  isBirthday() {
    if (((this.props.person != null ? this.props.person.birthday : undefined) != null) && (this.state != null ? this.state.current_date : undefined)) {
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
    return this.interval = setInterval((() => this.setCurrentTime()), 30000);
  }


  componentWillUnmount() {
    return clearInterval(this.interval);
  }


  onContactClick() {
    return this.props.setCurrentContact();
  }


  render() {
    if (!this.props.contact) { return ''; }

    const {
      photo
    } = this.props.contact;

    const class_names = {
      'employee' : true,
      'contact' : true,
      'employee_highlighted' : this.props.contact.id === this.props.current_contact_id,
      'contact_highlighted' : this.props.contact.id === this.props.current_contact_id
    };
    class_names[this.props.className] = true;

    return div({ className: classNames(class_names), onClick: this.onContactClick.bind(this) },
      div({ className: 'employee__photo' },
        (() => {
          if ((photo.thumb45.url != null) || (photo.thumb60.url != null)) {
            if (photo.thumb45.url != null) {
              img({ src: process.env.PHOTO_BASE_URL + photo.thumb45.url, className: 'employee__thumb45' });
            }
            if (photo.thumb60.url != null) {
              return img({ src: process.env.PHOTO_BASE_URL + photo.thumb60.url, className: 'employee__thumb60' });
            }
          } else {
            return avatar({ className: 'employee__avatar', gender: this.props.contact.gender, post_code: this.props.contact.post_code });
          }
        })()),

      div({ className: 'employee__info' },
        div({ className: 'employee__name' },
          (() => {
            if (this.props.contact.last_name) {
              return [
                span({ className: 'employee__last-name' },
                  this.props.contact.last_name),
                span({ className: 'employee__first-name' },
                  this.props.contact.first_name),
                span({ className: 'employee__middle-name' },
                  this.props.contact.middle_name)
              ];
            } else if (this.props.contact.function_title) {
              return this.props.contact.function_title;
            } else if (this.props.contact.location_title) {
              return this.props.contact.location_title;
            }
          })(),

          this.props.is_to_call ?
            svg({ className: 'small-icon employee__to-call', svg: ToCallIcon }) : undefined,

          this.props.is_favorite ?
            svg({ className: 'small-icon employee__favorite', svg: StarIcon }) : undefined),

        this.props.contact.post_title ?
          div({ className: 'employee__post_title' },
            this.props.contact.post_title) : undefined,

        (() => {
          if (!(this.props.hide != null ? this.props.hide.unit : undefined)) {
            if (this.props.node != null) {
              return div({ className: 'employee__organization_unit_title' },
                this.props.node.t);
            }
          }
        })(),

        this.props.show_location ?
          div({ className: 'employee__location' },
            this.props.contact.building ?
              span({ className: 'employee__location-building' },
                span({ className: 'employee__location-building-label' },
                  'Корпус '),
                span({ className: 'employee__location-building-number' },
                  this.props.contact.building)
              ) : undefined,
            this.props.contact.office ?
              span({ className: 'employee__location-office' },
                span({ className: 'employee__location-office-label' },
                  this.props.contact.building ?
                    ', кабинет '
                    :
                    'Кабинет '
                ),
                span({ className: 'employee__location-office-number' },
                  this.props.contact.office)
              ) : undefined
          ) : undefined
      ),

      isArray(this.props.contact.format_phones) && (this.props.contact.format_phones.length > 0) ?
        div({ className: 'employee__phones' },
          Array.from(this.props.contact.format_phones.slice(0, 3)).map((phone) =>
            div({ className: 'employee__phone', key: phone[1] },
              phone[1]))) : undefined,

      div({ className: 'employee__status-container' },
        (() => {
          if (this.props.contact.on_vacation) {
            return div({ className: 'employee__status employee__on-vacation' },
              'В отпуске');
          } else {
            if (this.isOnLunchNow()) {
              return div({ className: 'employee__status employee__on-lunch' },
                'Обеденный перерыв');
            }
          }
        })(),
        this.isBirthday() ?
          div({ className: 'employee__status employee__birthday' },
            'День рождения') : undefined
      )
    );
  }
}


const ConnectedContact = connect(mapStateToProps, mapDispatchToProps)(Contact);
const contact = React.createFactory(ConnectedContact);

export default ConnectedContact;
