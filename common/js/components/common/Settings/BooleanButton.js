import React from 'react';
import { connect } from 'react-redux';
import classNames from 'classnames';

import { svgIcon } from '@components/factories';

import { saveSetting } from '@actions/settings';

const mapStateToProps = (state, ownProps) => ({
  is_checked: state.settings[ownProps.setting]
});

const mapDispatchToProps = (dispatch, ownProps) => ({
  check() {
    return dispatch(saveSetting(ownProps.setting, true));
  },

  uncheck() {
    return dispatch(saveSetting(ownProps.setting, false));
  }
});

class SettingsBooleanButton extends React.Component {
  onClick() {
    if (this.props.is_checked) {
      return this.props.uncheck();
    } else {
      return this.props.check();
    }
  }

  render() {
    const class_name = classNames({
      'settings-boolean-button': true,
      'settings-boolean-button-checked': this.props.is_checked
    });

    return svgIcon({
      className: class_name,
      svg: this.props.svg,
      onClick: this.onClick.bind(this)
    });
  }
}

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(SettingsBooleanButton);
