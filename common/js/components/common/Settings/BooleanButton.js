/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import React from 'react';
import { connect } from 'react-redux';
import classNames from 'classnames';
import SvgIcon from '@components/common/SvgIcon';

import { saveSetting } from '@actions/settings';

const a = React.createFactory('a');
const div = React.createFactory('div');
const svg = React.createFactory(SvgIcon);


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

    return svg({ className: class_name, svg: this.props.svg, onClick: this.onClick.bind(this) });
  }
}


export default connect(mapStateToProps, mapDispatchToProps)(SettingsBooleanButton);
