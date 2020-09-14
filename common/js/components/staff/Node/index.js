import React from 'react';
import { connect } from 'react-redux';
import classNames from 'classnames';
import SvgIcon from '@components/common/SvgIcon';
import { Element as ScrollElement, scroller } from 'react-scroll';

import {
  collapseNode,
  saveCollapsedNode,
  expandNode,
  saveExpandedNode,
  setCurrentNodeId,
  scrolledToNode
} from '@actions/nodes';

import { popNodeInfo } from '@actions/layout';

const div = React.createFactory('div');
const svg = React.createFactory(SvgIcon);
const scroll_element = React.createFactory(ScrollElement);

import MinusIcon from '@icons/minus-square.svg';
import PlusIcon from '@icons/plus-square.svg';

const mapStateToProps = (state, ownProps) => ({
  node: state.nodes.tree[ownProps.node_id],
  is_expanded: state.nodes.expanded[ownProps.node_id] != null,
  is_current: ownProps.node_id === state.nodes.current_id,
  do_scroll: ownProps.node_id === state.nodes.scroll_to_id
});

const mapDispatchToProps = dispatch => {
  return {
    expand() {
      dispatch(expandNode(this.node_id));
      return dispatch(saveExpandedNode(this.node_id));
    },

    collapse() {
      dispatch(collapseNode(this.node_id));
      return dispatch(saveCollapsedNode(this.node_id));
    },

    setCurrentNode() {
      dispatch(setCurrentNodeId(this.node_id));
      return dispatch(popNodeInfo());
    },

    scrolledToNode() {
      return dispatch(scrolledToNode(this.node_id));
    }
  };
};

class Node extends React.Component {
  hasChildren() {
    return (
      +(this.props.node.c != null ? this.props.node.c.length : undefined) > 0
    );
  }

  componentDidUpdate(prevProps) {
    if (this.props.do_scroll) {
      scroller.scrollTo(`node-${this.props.node_id}`, {
        offset: -200,
        duration: 600,
        smooth: true,
        isDynamic: true,
        containerId: 'organization-structure-scroller'
      });
      return this.props.scrolledToNode();
    }
  }

  onExpandCollapseClick() {
    if (this.hasChildren()) {
      if (this.props.is_expanded) {
        return this.props.collapse();
      } else {
        return this.props.expand();
      }
    }
  }

  onNodeClick() {
    return this.props.setCurrentNode();
  }

  render() {
    if (this.props.node == null) {
      return '';
    }

    const has_children = this.hasChildren();

    const node_class_name = classNames({
      node: true,
      node_expanded: this.props.is_expanded,
      node_collapsed: !this.props.is_expanded,
      node_has_children: has_children,
      node_has_no_children: !has_children
    });

    const title_class_name = classNames({
      node__title: true,
      node__title_current: this.props.is_current,
      node__title_highlighted: this.props.is_highlighted
    });

    return div(
      { className: node_class_name },
      has_children
        ? div(
          {
            className: 'node__button',
            onClick: this.onExpandCollapseClick.bind(this)
          },
          svg({ className: 'node__button-open', svg: PlusIcon }),
          svg({ className: 'node__button-close', svg: MinusIcon })
        )
        : div({ className: 'node__button-stub' }),

      div(
        { className: 'node__content' },
        scroll_element(
          {
            className: title_class_name,
            onClick: this.onNodeClick.bind(this),
            name: `node-${this.props.node_id}`
          },
          this.props.node.t
        ),
        has_children
          ? div(
            { className: 'node__children' },
            Array.from(this.props.node.c).map(child_id =>
              node({ key: child_id, node_id: child_id })
            )
          )
          : undefined
      )
    );
  }
}

const ConnectedNode = connect(mapStateToProps, mapDispatchToProps)(Node);
var node = React.createFactory(ConnectedNode);

export default ConnectedNode;
