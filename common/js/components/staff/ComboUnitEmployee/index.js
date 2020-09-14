import React from 'react';
import classNames from 'classnames';

import SearchResultUnit from '@components/staff/SearchResultUnit';
import SomeoneWithButtons from '@components/staff/SomeoneWithButtons';

const div = React.createFactory('div');
const unit = React.createFactory(SearchResultUnit);
const employee = React.createFactory(SomeoneWithButtons);

class ComboUnitEmployee extends React.Component {
  render() {
    const class_names = { 'combo-unit-employee': true };
    class_names[this.props.className] = true;

    return div(
      { className: classNames(class_names) },
      this.props.unit_id != null
        ? unit({ unit_id: this.props.unit_id })
        : undefined,
      this.props.employment_id != null
        ? employee({
          employment_id: this.props.employment_id,
          hide: { unit: true }
        })
        : undefined
    );
  }
}

export default ComboUnitEmployee;
