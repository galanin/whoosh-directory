import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import classNames from 'classnames';
import { isArray, isEmpty, compact } from 'lodash';

import { addFavoriteUnit, removeFavoriteUnit } from '@actions/favorites';

import SvgIcon from '@components/common/SvgIcon';
import SomeoneWithButtons from '@components/staff/SomeoneWithButtons';
import NodeLink from '@components/staff/NodeLink';
import StarIcon from '@icons/star.svg';

const div = React.createFactory('div');
const svg = React.createFactory(SvgIcon);

const someone = React.createFactory(SomeoneWithButtons);
const node_link = React.createFactory(NodeLink);

const mapStateToProps = (state, ownProps) => {
  let node_id;
  const unit = state.units[ownProps.unit_id];
  const node = state.nodes.data[unit?.node_id];
  const tree_node = state.nodes.tree[unit?.node_id];
  const employments = compact(
    (node?.employ_ids || []).map(e_id => state.employments[e_id])
  );
  const child_nodes = compact(
    tree_node?.c || [].map(node_id => state.nodes.data[node_id])
  );

  return {
    unit,
    node,
    tree_node,
    is_favorite: state.favorites.unit_index[ownProps.unit_id],
    employments,
    child_nodes
  };
};

const mapDispatchToProps = dispatch => ({
  favorite(unit_id) {
    return dispatch(addFavoriteUnit(unit_id));
  },

  unfavorite(unit_id) {
    return dispatch(removeFavoriteUnit(unit_id));
  }
});

class NodeUnitInfo extends React.Component {
  static initClass() {
    this.propTypes = { unit_id: PropTypes.integer };
  }

  onClickFavorite() {
    if (this.props.is_favorite) {
      return this.props.unfavorite(this.props.unit_id);
    } else {
      return this.props.favorite(this.props.unit_id);
    }
  }

  render() {
    if (!this.props.unit) {
      return '';
    }

    const class_names = {
      unit: true,
      unit__scroller: true,
      'unit_is-favorite': this.props.is_favorite
    };
    class_names[this.props.className] = true;

    let child_class_name = 'list-item shadow';
    if (this.props.unit.head_id) {
      child_class_name += ' hierarchy-child';
    }

    return div(
      { className: classNames(class_names) },

      this.props.unit.short_title
        ? div(
          { className: 'unit__short-title' },
          this.props.unit.short_title,

          svg({
            className: 'medium-icon unit__favorite',
            svg: StarIcon,
            onClick: this.onClickFavorite.bind(this)
          })
        )
        : undefined,

      this.props.unit.long_title
        ? div(
          { className: 'unit__long-title' },
          this.props.unit.long_title,

          !this.props.unit.short_title
            ? svg({
              className: 'medium-icon unit__favorite',
              svg: StarIcon,
              onClick: this.onClickFavorite.bind(this)
            })
            : undefined
        )
        : undefined,

      this.props.unit.head_id
        ? someone({
          key: this.props.unit.head_id,
          employment_id: this.props.unit.head_id,
          hide: { unit: true },
          className: 'list-item shadow hierarchy-root'
        })
        : undefined,

      this.props.node && this.props.tree_node
        ? [
          this.props.employments.map(employment => {
            if (employment.id !== this.props.unit.head_id) {
              return someone({
                key: employment.id,
                employment_id: employment.id,
                hide: { unit: true },
                className: child_class_name
              });
            }
          }),

          isArray(this.props.node?.contact_ids)
            ? this.props.node.contact_ids.map(contact_id =>
              someone({
                key: contact_id,
                contact_id,
                hide: { unit: true },
                className: child_class_name
              })
            )
            : undefined,

          this.props.child_nodes.map(child_node =>
            node_link({
              key: child_node.id,
              node_id: child_node.id,
              className: child_class_name
            })
          )
        ]
        : undefined
    );
  }
}
NodeUnitInfo.initClass();

export default connect(mapStateToProps, mapDispatchToProps)(NodeUnitInfo);
