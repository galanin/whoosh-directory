/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS205: Consider reworking code to avoid use of IIFEs
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import React from 'react';
import { connect } from 'react-redux';
import classNames from 'classnames';

const div = React.createFactory('div');

import NodeEmploymentInfo from '@components/staff/NodeEmploymentInfo';
const employee = React.createFactory(NodeEmploymentInfo);

import NodeUnitInfo from '@components/staff/NodeUnitInfo';
const unit = React.createFactory(NodeUnitInfo);


const mapStateToProps = function(state) {
  const node_id = state.nodes.current_id;
  const node = state.nodes.data[node_id];
  const child_node_ids = state.nodes.tree[node_id] != null ? state.nodes.tree[node_id].c : undefined;

  return {
    node,
    child_ids: child_node_ids
  };
};


const mapDispatchToProps = dispatch => ({});


class NodeInfo extends React.Component {

  render() {
    if (this.props.node == null) { return ''; }

    const class_names = {
      'node-info' : true,
      'socket' : true
    };
    class_names[this.props.className] = true;

    return div({ className: classNames(class_names) },

      (() => {
        if (this.props.node.employment_id != null) {
          return employee({ employment_id: this.props.node.employment_id, className: 'plug' });
        } else if (this.props.node.unit_id != null) {
          return unit({ unit_id: this.props.node.unit_id, className: 'plug' });
        }
      })());
  }
}


export default connect(mapStateToProps, mapDispatchToProps)(NodeInfo);
