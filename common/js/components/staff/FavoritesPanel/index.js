/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import React from 'react';
import { connect } from 'react-redux';
import classNames from 'classnames';

import { popFavorites } from '@actions/layout';

import SvgIcon from '@components/common/SvgIcon';
import StarIcon from '@icons/star.svg';

const div = React.createFactory('div');
const span = React.createFactory('span');
const svg = React.createFactory(SvgIcon);


const mapStateToProps = (state, ownProps) => ({
  employee_counter: state.favorites.favorite_people.length,
  unit_counter: state.favorites.favorite_units.length
});


const mapDispatchToProps = (dispatch, ownProps) => ({
  clickFavorites() {
    return dispatch(popFavorites());
  }
});


class FavoritesPanel extends React.Component {

  onClick() {
    return this.props.clickFavorites();
  }


  render() {
    const class_names = {
      'favorites-panel' : true,
      'favorites-panel_counter-highlighted' : this.props.counter > 0
    };
    class_names[this.props.className] = true;

    return div({ className: classNames(class_names), onClick: this.onClick.bind(this) },
      svg({ className: 'medium-icon favorites-panel__icon', svg: StarIcon }),
      span({ className: 'favorites-panel__title' },
        'Избранное'),
      span({ className: 'favorites-panel__counter' },
        this.props.employee_counter),
      span({ className: 'favorites-panel__counter' },
        this.props.unit_counter)
    );
  }
}


export default connect(mapStateToProps, mapDispatchToProps)(FavoritesPanel);
