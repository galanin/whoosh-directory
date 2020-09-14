import React from 'react';
import classNames from 'classnames';

import SettingsBooleanButtons from '@components/common/Settings/BooleanButton';
const setting_boolean = React.createFactory(SettingsBooleanButtons);

import SvgIcon from '@components/common/SvgIcon';
import Location from '@icons/location.svg';

const div = React.createFactory('div');
const span = React.createFactory('span');
const svg = React.createFactory(SvgIcon);

class SettingsPanel extends React.Component {
  render() {
    const class_names = { 'settings-panel': true };
    class_names[this.props.className] = true;

    return div(
      { className: classNames(class_names) },
      setting_boolean({
        setting: 'search_results__show_location',
        svg: Location,
        className: 'settings-panel__button'
      })
    );
  }
}

export default SettingsPanel;
