import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import classNames from 'classnames';

import { div, img, commonAvatar } from '@components/factories';

import { goToNodeInStructure } from '@actions/nodes';
import { setHighlightedUnitId } from '@actions/current';
import { popNodeInfo, popStructure } from '@actions/layout';

const mapStateToProps = function(state, ownProps) {
  const node = state.nodes.data[ownProps.node_id];
  const employment = state.employments[node?.employment_id];

  return {
    node,
    tree_node: state.nodes.tree[ownProps.node_id],
    employment,
    person: state.people[employment?.person_id],
    unit: state.units[node?.unit_id]
  };
};

const mapDispatchToProps = function(dispatch, ownProps) {
  return {
    click() {
      dispatch(goToNodeInStructure(this.node.id));
      dispatch(popNodeInfo());
      return dispatch(popStructure());
    }
  };
};

class NodeLink extends React.Component {
  onUnitClick() {
    return this.props.click();
  }

  linkContent() {
    if (this.props.unit) {
      return [
        this.props.unit.short_title
          && div(
            { className: 'node-link__unit-short-title', key: 'short' },
            this.props.unit.short_title
          ),

        this.props.unit.long_title
          && div(
            { className: 'node-link__unit-long-title', key: 'long' },
            this.props.unit.long_title
          )
      ];
    } else if (this.props.employment) {
      const photo = this.props.person?.photo;

      return div(
        { className: 'node-link__employee-link' },
        div(
          { className: 'node-link__employee-photo' },
          photo?.thumb39?.url
            ? img({
              src: process.env.PHOTO_BASE_URL + photo.thumb39.url,
              className: 'node-link__employee-thumb39'
            })
            : commonAvatar({
              className: 'node-link__avatar',
              gender: this.props.person?.gender,
              post_code: this.props.employment.post_code
            })
        ),

        div(
          { className: 'node-link__employment-post-title' },
          this.props.employment.post_title
        )
      );
    }
  }

  render() {
    const class_names = { 'node-link': true };
    class_names[this.props.className] = true;

    return div(
      {
        className: classNames(class_names),
        onClick: this.onUnitClick.bind(this)
      },
      this.linkContent()
    );
  }
}
NodeLink.propTypes = { node_id: PropTypes.integer };

export default connect(mapStateToProps, mapDispatchToProps)(NodeLink);
