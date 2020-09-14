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
  const node = state.nodes.data[unit != null ? unit.node_id : undefined];
  const tree_node = state.nodes.tree[unit != null ? unit.node_id : undefined];
  const employments = compact(
    (node != null ? node.employ_ids : undefined) || []
  ).map(e_id => state.employments[e_id]);
  const child_nodes = compact(
    (() => {
      const result = [];
      for (node_id of (tree_node != null ? tree_node.c : undefined) || []) {
        result.push(state.nodes.data[node_id]);
      }
      return result;
    })()
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
    if (this.props.unit == null) {
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

      this.props.unit.short_title != null
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

      this.props.unit.long_title != null
        ? div(
          { className: 'unit__long-title' },
          this.props.unit.long_title,

          this.props.unit.short_title == null
            ? svg({
              className: 'medium-icon unit__favorite',
              svg: StarIcon,
              onClick: this.onClickFavorite.bind(this)
            })
            : undefined
        )
        : undefined,

      this.props.unit.head_id != null
        ? someone({
          key: this.props.unit.head_id,
          employment_id: this.props.unit.head_id,
          hide: { unit: true },
          className: 'list-item shadow hierarchy-root'
        })
        : undefined,

      this.props.node != null && this.props.tree_node != null
        ? [
          (() => {
            const result = [];
            for (let employment of this.props.employments) {
              if (employment.id !== this.props.unit.head_id) {
                result.push(
                  someone({
                    key: employment.id,
                    employment_id: employment.id,
                    hide: { unit: true },
                    className: child_class_name
                  })
                );
              } else {
                result.push(undefined);
              }
            }
            return result;
          })(),

          isArray(
            this.props.node != null ? this.props.node.contact_ids : undefined
          )
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
