import React from 'react';
import classNames from 'classnames';

import {
  div,
  searchResultUnit,
  someoneWithButtons
} from '@components/factories';

class ComboUnitEmployee extends React.Component {
  searchResult() {
    if (this.props.unit_id) {
      return searchResultUnit({ unit_id: this.props.unit_id });
    }
  }

  someone() {
    if (this.props.employment_id) {
      return someoneWithButtons({
        employment_id: this.props.employment_id,
        hide: { unit: true }
      });
    }
  }

  render() {
    const class_names = { 'combo-unit-employee': true };
    class_names[this.props.className] = true;

    return div(
      { className: classNames(class_names) },
      this.searchResult(),
      this.someone()
    );
  }
}

export default ComboUnitEmployee;
