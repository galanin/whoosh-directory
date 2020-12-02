import React from 'react';
import { connect } from 'react-redux';
import { isArray } from 'lodash';
import classNames from 'classnames';

import { div, svgIcon, someoneWithButtons } from '@components/factories';

import { expandSubUnit, collapseSubUnit } from '@actions/expand_sub_units';

import Triangle from '@icons/triangle.svg';

const mapStateToProps = (state, ownProps) => {
  const extra = state.unit_extras[ownProps.unit_id];
  return {
    unit_data: state.units[ownProps.unit_id],
    unit_titles: state.unit_titles || {},
    loading: extra?.loading,
    loaded: extra?.loaded,
    is_expanded: state.expanded_sub_units[ownProps.unit_id]
  };
};

const mapDispatchToProps = (dispatch, ownProps) => ({
  expand() {
    return dispatch(expandSubUnit(ownProps.unit_id));
  },

  collapse() {
    return dispatch(collapseSubUnit(ownProps.unit_id));
  }
});

class OrganizationSubUnit extends React.Component {
  onExpandCollapseClick() {
    if (this.props.is_expanded) {
      return this.props.collapse();
    } else {
      return this.props.expand();
    }
  }

  subUnits() {
    if (this.props.is_expanded && isArray(this.props.unit_data?.child_ids)) {
      return div(
        { className: 'sub-unit__sub-units' },
        this.props.unit_data.child_ids.map(sub_unit_id =>
          sub_unit({
            key: 'sub-unit-' + sub_unit_id,
            unit_id: sub_unit_id
          })
        )
      );
    }
  }

  subUnitsEmployee() {
    if (this.props.is_expanded && isArray(this.props.unit_data?.employ_ids)) {
      return div(
        { className: 'sub-unit__employees' },
        this.props.unit_data.employ_ids.map(employment_id =>
          someoneWithButtons({
            key: employment_id,
            employment_id,
            hide: { unit: true },
            className: 'list-item shadow'
          })
        )
      );
    }
  }

  render() {
    if (!this.props.unit_data) {
      return '';
    }

    const sub_unit_class_names = classNames({
      'sub-unit': true,
      'sub-unit_expanded': this.props.is_expanded,
      'sub-unit_collapsed': !this.props.is_expanded
    });

    return div(
      { className: sub_unit_class_names },
      div(
        {
          className: 'sub-unit__head',
          onClick: this.onExpandCollapseClick.bind(this)
        },
        div(
          { className: 'sub-unit__button' },
          svgIcon({ className: 'sub-unit__triangle', svg: Triangle })
        ),
        div({ className: 'sub-unit__title' }, this.props.unit_data.list_title)
      ),
      div(
        { className: 'sub-unit__content' },

        this.subUnitsEmployee(),

        this.subUnits()
      )
    );
  }
}

const ConnectedOrganizationSubUnit = connect(
  mapStateToProps,
  mapDispatchToProps
)(OrganizationSubUnit);
var sub_unit = React.createFactory(ConnectedOrganizationSubUnit);

export default ConnectedOrganizationSubUnit;
