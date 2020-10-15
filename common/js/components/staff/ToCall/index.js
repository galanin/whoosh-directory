import React from 'react';
import { connect } from 'react-redux';
import classNames from 'classnames';

import SvgIcon from '@components/common/SvgIcon';
import {
  addEmploymentToCall,
  addContactToCall,
  checkEmploymentToCall,
  checkContactToCall,
  destroyEmploymentToCall,
  destroyContactToCall
} from '@actions/to_call';

const div = React.createFactory('div');
const svg = React.createFactory(SvgIcon);

import Employee from '@components/staff/Employee';
const employee = React.createFactory(Employee);

import Contact from '@components/staff/Contact';
const contact = React.createFactory(Contact);

import CheckIcon from '@icons/checked.svg';
import DestroyIcon from '@icons/recycle-bin.svg';

const mapStateToProps = (state, ownProps) => {
  const to_call = state.to_call?.data?.[ownProps.to_call_id];
  const is_unchecked = () => {
    if (to_call.employment_id) {
      return state.to_call.unchecked_employment_index[to_call.employment_id];
    } else if (to_call.contact_id) {
      return state.to_call.unchecked_contact_index[to_call.contact_id];
    }
  };

  return {
    to_call,
    is_unchecked
  };
};

const mapDispatchToProps = (dispatch, ownProps) => ({
  addToCall(to_call) {
    if (to_call.employment_id) {
      return dispatch(addEmploymentToCall(to_call.employment_id));
    } else if (to_call.contact_id) {
      return dispatch(addContactToCall(to_call.contact_id));
    }
  },

  checkToCall(to_call) {
    if (to_call.employment_id) {
      return dispatch(checkEmploymentToCall(to_call.employment_id));
    } else if (to_call.contact_id) {
      return dispatch(checkContactToCall(to_call.contact_id));
    }
  },

  destroyToCall(to_call) {
    if (to_call.employment_id) {
      return dispatch(destroyEmploymentToCall(to_call.employment_id));
    } else if (to_call.contact_id) {
      return dispatch(destroyContactToCall(to_call.contact_id));
    }
  }
});

class ToCall extends React.Component {
  onCheck() {
    if (this.props.is_unchecked()) {
      return this.props.checkToCall(this.props.to_call);
    } else {
      return this.props.addToCall(this.props.to_call);
    }
  }

  onDestroyToCall() {
    return this.props.destroyToCall(this.props.to_call);
  }

  render() {
    if (!this.props.to_call) {
      return '';
    }

    const class_names = {
      'to-call': true,
      'employee-buttons-container': true,
      'to-call_is-checked': !this.props.is_unchecked()
    };
    class_names[this.props.className] = true;

    return div(
      { className: classNames(class_names) },

      this.props.to_call.employment_id
        ? employee({
          employment_id: this.props.to_call.employment_id,
          className: 'to-call__employee'
        })
        : undefined,

      this.props.to_call.contact_id
        ? contact({
          contact_id: this.props.to_call.contact_id,
          className: 'to-call__contact'
        })
        : undefined,

      div(
        { className: 'to-call__buttons employee-buttons-container__buttons' },
        div(
          {
            className:
              'to-call__button to-call__check-to-call employee-buttons-container__button',
            onClick: this.onCheck.bind(this)
          },
          svg({
            className: 'medium-icon to-call__icon to-call__check',
            svg: CheckIcon
          })
        ),

        div(
          {
            className:
              'to-call__button to-call__destroy-to-call employee-buttons-container__button',
            onClick: this.onDestroyToCall.bind(this)
          },
          svg({
            className: 'medium-icon to-call__icon to-call__destroy',
            svg: DestroyIcon
          })
        )
      )
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(ToCall);
