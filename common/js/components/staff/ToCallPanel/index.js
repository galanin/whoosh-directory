import React from 'react';
import { connect } from 'react-redux';
import classNames from 'classnames';

import { popToCall } from '@actions/layout';

import SvgIcon from '@components/common/SvgIcon';
import ToCallIcon from '@icons/call.svg';
import CheckedIcon from '@icons/checked.svg';

const div = React.createFactory('div');
const span = React.createFactory('span');
const svg = React.createFactory(SvgIcon);

const mapStateToProps = (state, ownProps) => ({
  counter:
    __guard__(
      state.to_call?.unchecked,
      x => x.length
    ) || 0
});

const mapDispatchToProps = (dispatch, ownProps) => ({
  clickToCallList() {
    return dispatch(popToCall());
  }
});

class ToCallPanel extends React.Component {
  onClick() {
    return this.props.clickToCallList();
  }

  render() {
    const class_names = {
      'to-call-panel': true,
      'to-call-panel_counter-highlighted': this.props.counter > 0
    };
    class_names[this.props.className] = true;

    return (
      <div
        className={classNames(class_names)}
        onClick={this.onClick.bind(this)}
      >
        <SvgIcon className="medium-icon to-call-panel__icon" svg={ToCallIcon} />
        {this.props.counter > 0 ? (
          <span className="to-call-panel__counter">{this.props.counter}</span>
        ) : (
          <SvgIcon className="to-call-panel__empty" svg={CheckedIcon} />
        )}
      </div>
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(ToCallPanel);

const __guard__ = (value, transform) => {
  return typeof value !== 'undefined' && value !== null
    ? transform(value)
    : undefined;
};
