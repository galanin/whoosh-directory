import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import classNames from 'classnames';
import { isArray } from 'lodash';

import {
  div,
  employeeWithButtons,
  someoneWithButtons,
  nodeLink
} from '@components/factories';

import {
  addFavoriteEmployment,
  removeFavoriteEmployment,
  addFavoriteUnit
} from '@actions/favorites';

import StarIcon from '@icons/star.svg';

const mapStateToProps = (state, ownProps) => {
  const employment = state.employments[ownProps.employment_id];
  const tree_node = state.nodes.tree[employment?.node_id];
  const node = state.nodes.data[employment?.node_id];

  return {
    employment,
    node,
    tree_node,
    employ_ids: node?.employ_ids,
    child_ids: tree_node?.c,
    is_favorite: state.favorites.employment_index[ownProps.employment_id]
  };
};

const mapDispatchToProps = dispatch => ({
  favorite(employment_id) {
    return dispatch(addFavoriteUnit(employment_id));
  },

  unfavorite(employment_id) {
    return dispatch(removeFavoriteEmployment(employment_id));
  }
});

class NodeEmploymentInfo extends React.Component {
  onClickFavorite() {
    if (this.props.is_favorite) {
      return this.props.unfavorite(this.props.employment_id);
    } else {
      return this.props.favorite(this.props.employment_id);
    }
  }

  employeeTree() {
    if (this.props.node) {
      if (isArray(this.props.employ_ids)) {
        for (let employment_id of Array.from(this.props.employ_ids)) {
          div(
            { className: 'hierarchy-child' },
            someoneWithButtons({
              key: employment_id,
              employment_id,
              hide: { unit: true },
              className: 'list-item shadow'
            })
          );
        }
      }

      if (isArray(this.props.node?.contact_ids)) {
        for (let contact_id of Array.from(this.props.node.contact_ids)) {
          div(
            { className: 'hierarchy-child' },
            someoneWithButtons({
              key: contact_id,
              contact_id,
              hide: { unit: true },
              className: 'list-item shadow'
            })
          );
        }
      }

      if (isArray(this.props.child_ids)) {
        return Array.from(this.props.child_ids).map(child_node_id =>
          div(
            { className: 'hierarchy-child' },
            nodeLink({
              key: 'child-node-' + child_node_id,
              node_id: child_node_id,
              className: 'list-item shadow'
            })
          )
        );
      }
    }
  }

  render() {
    if (!this.props.employment) {
      return '';
    }

    const class_names = {
      'node-employment': true,
      'node-employment__scroller': true,
      'node-employment_is-favorite': this.props.is_favorite
    };
    class_names[this.props.className] = true;

    return div(
      { className: classNames(class_names) },

      this.props.employment.post_title
        ? div(
          { className: 'node-employment__post-title' },
          this.props.employment.post_title
        )
        : undefined,

      div(
        { className: 'hierarchy-root' },
        employeeWithButtons({
          employment_id: this.props.employment_id,
          hide: { unit: true, post: true },
          className: 'list-item shadow'
        })
      ),
      this.employeeTree()
    );
  }
}
NodeEmploymentInfo.propTypes = { employment_id: PropTypes.integer };

export default connect(mapStateToProps, mapDispatchToProps)(NodeEmploymentInfo);
