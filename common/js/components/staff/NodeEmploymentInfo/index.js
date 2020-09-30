import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import classNames from 'classnames';
import { isArray } from 'lodash';

import {
  addFavoriteEmployment,
  removeFavoriteEmployment,
  addFavoriteUnit
} from '@actions/favorites';

import SvgIcon from '@components/common/SvgIcon';
import EmployeeWithButtons from '@components/staff/EmployeeWithButtons';
import SomeoneWithButtons from '@components/staff/SomeoneWithButtons';
import NodeLink from '@components/staff/NodeLink';
import StarIcon from '@icons/star.svg';

const div = React.createFactory('div');
const svg = React.createFactory(SvgIcon);

const employee = React.createFactory(EmployeeWithButtons);
const someone = React.createFactory(SomeoneWithButtons);
const node_link = React.createFactory(NodeLink);

const mapStateToProps = (state, ownProps) => {
  const employment = state.employments[ownProps.employment_id];
  const tree_node =
    state.nodes.tree[employment != null ? employment.node_id : undefined];
  const node =
    state.nodes.data[employment != null ? employment.node_id : undefined];

  return {
    employment,
    node,
    tree_node,
    employ_ids: node != null ? node.employ_ids : undefined,
    child_ids: tree_node != null ? tree_node.c : undefined,
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
  static initClass() {
    this.propTypes = { employment_id: PropTypes.integer };
  }

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
            someone({
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
            someone({
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
            node_link({
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
    if (this.props.employment == null) {
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

      this.props.employment.post_title != null
        ? div(
          { className: 'node-employment__post-title' },
          this.props.employment.post_title
        )
        : undefined,

      div(
        { className: 'hierarchy-root' },
        employee({
          employment_id: this.props.employment_id,
          hide: { unit: true, post: true },
          className: 'list-item shadow'
        })
      ),
      this.employeeTree()
    );
  }
}
NodeEmploymentInfo.initClass();

export default connect(mapStateToProps, mapDispatchToProps)(NodeEmploymentInfo);
