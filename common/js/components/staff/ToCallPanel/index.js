import React from 'react';
import { connect } from 'react-redux';
import classNames from 'classnames';

import { div, span, svgIcon } from '@components/factories';

import { popToCall } from '@actions/layout';

import ToCallIcon from '@icons/call.svg';
import CheckedIcon from '@icons/checked.svg';

const mapStateToProps = (state, ownProps) => ({
  counter: state.to_call?.unchecked?.length || 0
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

    return div(
      { className: classNames(class_names), onClick: this.onClick.bind(this) },
      svgIcon({
        className: 'medium-icon to-call-panel__icon',
        svg: ToCallIcon
      }),
      span({ className: 'to-call-panel__title' }, 'Планировщик'),
      this.props.counter > 0
        ? span({ className: 'to-call-panel__counter' }, this.props.counter)
        : svgIcon({ className: 'to-call-panel__empty', svg: CheckedIcon })
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(ToCallPanel);
