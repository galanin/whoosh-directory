import React from 'react';
import { connect } from 'react-redux';
import classNames from 'classnames';

const div = React.createFactory('div');

import NodeEmploymentInfo from '@components/staff/NodeEmploymentInfo';
const employee = React.createFactory(NodeEmploymentInfo);

import NodeUnitInfo from '@components/staff/NodeUnitInfo';
const unit = React.createFactory(NodeUnitInfo);

const mapStateToProps = state => {
  const node_id = state.nodes.current_id;
  const node = state.nodes.data[node_id];
  const child_node_ids =
    state.nodes.tree[node_id] != null ? state.nodes.tree[node_id].c : undefined;

  return {
    node,
    child_ids: child_node_ids
  };
};

const mapDispatchToProps = dispatch => ({});

class NodeInfo extends React.Component {
  employeeOrUnit() {
    if (this.props.node.employment_id) {
      return employee({
        employment_id: this.props.node.employment_id,
        className: 'plug'
      });
    } else if (this.props.node.unit_id) {
      return unit({ unit_id: this.props.node.unit_id, className: 'plug' });
    }
  }

  render () {
    if (this.props.node == null) {
      return '';
    }

    const class_names = {
      'node-info': true,
      socket: true
    };
    class_names[this.props.className] = true;

    return div(
      { className: classNames(class_names) },
      this.employeeOrUnit()
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(NodeInfo);
