import React from 'react';
import classNames from 'classnames';

import { div, settingsBooleanButtons } from '@components/factories';

import Location from '@icons/location.svg';

class SettingsPanel extends React.Component {
  render() {
    const class_names = { 'settings-panel': true };
    class_names[this.props.className] = true;

    return div(
      { className: classNames(class_names) },
      settingsBooleanButtons({
        setting: 'search_results__show_location',
        svg: Location,
        className: 'settings-panel__button'
      })
    );
  }
}

export default SettingsPanel;
