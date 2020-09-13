import React from 'react';
import { connect } from 'react-redux';
import classNames from 'classnames';
import { includes } from 'lodash';

import SvgIcon from '@components/common/SvgIcon';

import {
  addEmploymentToCall,
  addContactToCall,
  checkEmploymentToCall,
  checkContactToCall
} from '@actions/to_call';
import {
  addFavoriteEmployment,
  addFavoriteContact,
  removeFavoriteEmployment,
  removeFavoriteContact
} from '@actions/favorites';

import ToCallIcon from '@icons/call.svg';
import StarIcon from '@icons/star.svg';

const mapStateToProps = (state, ownProps) => {
  if (ownProps.employment_id != null) {
    return {
      employment: state.employments[ownProps.employment_id],
      is_to_call:
        state.to_call.unchecked_employment_index[ownProps.employment_id],
      is_favorite: state.favorites.employment_index[ownProps.employment_id]
    };
  } else if (ownProps.contact_id != null) {
    return {
      contact: state.contacts[ownProps.contact_id],
      is_to_call: state.to_call.unchecked_contact_index[ownProps.contact_id],
      is_favorite: state.favorites.contact_index[ownProps.contact_id]
    };
  }
};

const mapDispatchToProps = (dispatch, ownProps) => ({
  addToCall() {
    if (ownProps.employment_id != null) {
      return dispatch(addEmploymentToCall(ownProps.employment_id));
    } else if (ownProps.contact_id != null) {
      return dispatch(addContactToCall(ownProps.contact_id));
    }
  },

  checkToCall() {
    if (ownProps.employment_id != null) {
      return dispatch(checkEmploymentToCall(ownProps.employment_id));
    } else if (ownProps.contact_id != null) {
      return dispatch(checkContactToCall(ownProps.contact_id));
    }
  },

  favorite() {
    if (ownProps.employment_id != null) {
      return dispatch(addFavoriteEmployment(ownProps.employment_id));
    } else if (ownProps.contact_id != null) {
      return dispatch(addFavoriteContact(ownProps.contact_id));
    }
  },

  unfavorite() {
    if (ownProps.employment_id != null) {
      return dispatch(removeFavoriteEmployment(ownProps.employment_id));
    } else if (ownProps.contact_id != null) {
      return dispatch(removeFavoriteContact(ownProps.contact_id));
    }
  }
});

class SomeoneButtons extends React.Component {
  onAddToCall() {
    if (this.props.is_to_call) {
      return this.props.checkToCall();
    } else {
      return this.props.addToCall();
    }
  }

  onFavorite() {
    if (this.props.is_favorite) {
      return this.props.unfavorite();
    } else {
      return this.props.favorite();
    }
  }

  render() {
    const class_names = {
      'employee-buttons': true,
      'employee-buttons_is-to-call-scheduled': this.props.is_to_call,
      'employee-buttons_is-favorite': this.props.is_favorite
    };
    class_names[this.props.className] = true;

    return (
      <div className={classNames(class_names)}>
        <div
          className="employee-buttons__button employee-buttons__to-call"
          onClick={this.onAddToCall.bind(this)}
        >
          <SvgIcon
            className="medium-icon employee-buttons__icon"
            svg={ToCallIcon}
          />
          <span className="employee-buttons__label">
            {this.props.is_to_call
              ? 'Запланирован звонок'
              : 'Запланировать звонок'}
          </span>
        </div>

        <div
          className="employee-buttons__button employee-buttons__favorite"
          onClick={this.onFavorite.bind(this)}
        >
          <SvgIcon
            className="medium-icon employee-buttons__icon"
            svg={StarIcon}
          />
          <span className="employee-buttons__label">
            {this.props.is_favorite ? 'В избранном' : 'Добавить в избранное'}
          </span>
        </div>
      </div>
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(SomeoneButtons);
