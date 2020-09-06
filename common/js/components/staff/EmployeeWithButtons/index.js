/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS103: Rewrite code to no longer use __guard__, or convert again using --optional-chaining
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import React from 'react';
import { connect } from 'react-redux';
import classNames from 'classnames';
import { includes } from 'lodash';

import SvgIcon from '@components/common/SvgIcon';

import { addToCall, checkToCall } from '@actions/to_call';
import { addFavoriteEmployment, removeFavoriteEmployment } from '@actions/favorites';


const div = React.createFactory('div');
const svg = React.createFactory(SvgIcon);

import Employee from '@components/staff/Employee';
const employee = React.createFactory(Employee);

import ToCallIcon from '@icons/call.svg';
import StarIcon from '@icons/star.svg';


const mapStateToProps = (state, ownProps) => ({
  is_to_call  : __guard__(state.to_call != null ? state.to_call.unchecked_employment_index : undefined, x => x[ownProps.employment_id]),
  is_favorite : state.favorites.employment_index[ownProps.employment_id]
});


const mapDispatchToProps = (dispatch, ownProps) => ({
  addToCall() {
    return dispatch(addToCall(ownProps.employment_id));
  },

  checkToCall() {
    return dispatch(checkToCall(ownProps.employment_id));
  },

  favorite() {
    return dispatch(addFavoriteEmployment(ownProps.employment_id));
  },

  unfavorite() {
    return dispatch(removeFavoriteEmployment(ownProps.employment_id));
  }
});


class EmployeeWithButtons extends React.Component {

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
      'employee-with-buttons' : true,
      'employee-buttons-container' : true,
      'employee-with-buttons_is-to-call-scheduled' : this.props.is_to_call,
      'employee-with-buttons_is-favorite' : this.props.is_favorite
    };
    class_names[this.props.className] = true;

    return div({ className: classNames(class_names) },
      employee({employment_id: this.props.employment_id, hide: this.props.hide, className: 'employee-with-buttons__employee'}),
      div({ className: 'employee-with-buttons__buttons employee-buttons-container__buttons' },
        div({ className: 'employee-with-buttons__button employee-with-buttons__to-call employee-buttons-container__button', onClick: this.onAddToCall.bind(this) },
          svg({ className: 'medium-icon employee-with-buttons__icon', svg: ToCallIcon })),
        div({ className: 'employee-with-buttons__button employee-with-buttons__favorite employee-buttons-container__button', onClick: this.onFavorite.bind(this) },
          svg({ className: 'medium-icon employee-with-buttons__icon', svg: StarIcon }))));
  }
}


export default connect(mapStateToProps, mapDispatchToProps)(EmployeeWithButtons);

function __guard__(value, transform) {
  return (typeof value !== 'undefined' && value !== null) ? transform(value) : undefined;
}