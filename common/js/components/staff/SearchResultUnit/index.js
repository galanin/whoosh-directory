import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import classNames from 'classnames';

import { goToNodeInStructure } from '@actions/nodes';
import { popNodeInfo, popStructure } from '@actions/layout';

const div = React.createFactory('div');

const mapStateToProps = (state, ownProps) => ({
  unit: state.units[ownProps.unit_id]
});

const mapDispatchToProps = (dispatch, ownProps) => ({
  goToNode(node_id) {
    dispatch(goToNodeInStructure(node_id));
    dispatch(popNodeInfo());
    return dispatch(popStructure());
  }
});

class SearchResultUnit extends React.Component {
  onUnitClick() {
    return this.props.goToNode(this.props.unit.node_id);
  }

  render() {
    if (!this.props.unit) {
      return '';
    }

    const class_names = { 'search-result-unit': true };
    class_names[this.props.className] = true;

    return div(
      {
        className: classNames(class_names),
        onClick: this.onUnitClick.bind(this)
      },
      this.props.unit?.short_title
        ? div(
          { className: 'search-result-unit__short-title' },
          this.props.unit.short_title
        )
        : undefined,
      this.props.unit?.long_title
        ? div(
          { className: 'search-result-unit__long-title' },
          this.props.unit.long_title
        )
        : undefined
    );
  }
}
SearchResultUnit.propTypes = { unit_id: PropTypes.integer };

export default connect(mapStateToProps, mapDispatchToProps)(SearchResultUnit);
