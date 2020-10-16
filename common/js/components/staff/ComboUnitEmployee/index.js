import React from 'react';
import classNames from 'classnames';

import {
  div,
  searchResultUnit,
  someoneWithButtons
} from '@components/factories';

class ComboUnitEmployee extends React.Component {
  render() {
    const class_names = { 'combo-unit-employee': true };
    class_names[this.props.className] = true;

    return div(
      { className: classNames(class_names) },
      this.props.unit_id
        ? searchResultUnit({ unit_id: this.props.unit_id })
        : undefined,
      this.props.employment_id
        ? someoneWithButtons({
          employment_id: this.props.employment_id,
          hide: { unit: true }
        })
        : undefined
    );
  }
}

export default ComboUnitEmployee;
