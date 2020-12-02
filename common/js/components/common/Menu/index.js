import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import classNames from 'classnames';

import { RESULTS_SOURCE_BIRTHDAY } from '@constants/search';

import { setBirthdayPeriodByShortcut } from '@actions/birthday_period';
import { setResultsSource } from '@actions/search';

import { closeMenu } from '@actions/menu';
import {
  popSearchResults,
  popStructure,
  popFavorites,
  popToCall
} from '@actions/layout';

import { a, div, svgIcon } from '@components/factories';

import CloseButton from '@icons/close_button.svg';

const mapStateToProps = (state, ownProps) => ({
  open: state.menu.open
});

const mapDispatchToProps = (dispatch, ownProps) => ({
  closeMenu() {
    return dispatch(closeMenu());
  },

  goSearch() {
    return dispatch(popSearchResults());
  },

  goStructure() {
    return dispatch(popStructure());
  },

  goFavorites() {
    return dispatch(popFavorites());
  },

  goToCall() {
    return dispatch(popToCall());
  },

  goBirthdays(shortcut) {
    dispatch(setBirthdayPeriodByShortcut(shortcut));
    dispatch(setResultsSource(RESULTS_SOURCE_BIRTHDAY));
    return dispatch(popSearchResults());
  }
});

class Menu extends React.Component {
  onCloseButtonClick(event) {
    return this.props.closeMenu();
  }

  onSearchChosen(event) {
    event.preventDefault();
    this.props.goSearch();
    return this.props.closeMenu();
  }

  onStructureChosen(event) {
    event.preventDefault();
    this.props.goStructure();
    return this.props.closeMenu();
  }

  onFavoritesChosen(event) {
    event.preventDefault();
    this.props.goFavorites();
    return this.props.closeMenu();
  }

  onToCallChosen(event) {
    event.preventDefault();
    this.props.goToCall();
    return this.props.closeMenu();
  }

  onBirthdaysTodayChosen(event) {
    event.preventDefault();
    this.props.goBirthdays(event.currentTarget.getAttribute('shortcut'));
    return this.props.closeMenu();
  }

  render() {
    const class_names = {
      menu: true,
      'menu_is-open': this.props.open
    };

    return div(
      { className: classNames(class_names) },
      div(
        { className: 'menu-scroller' },
        div(
          {
            className: 'employee-info__close-button',
            onClick: this.onCloseButtonClick.bind(this)
          },
          svgIcon({
            className: 'employee-info__close-button-cross',
            svg: CloseButton
          })
        ),

        div({ className: 'menu-title' }, 'Справочник сотрудников'),

        a(
          {
            className: 'menu-item menu-item__search',
            onClick: this.onSearchChosen.bind(this),
            href: '#'
          },
          'Поиск'
        ),

        a(
          {
            className: 'menu-item menu-item__structure',
            onClick: this.onStructureChosen.bind(this),
            href: '#'
          },
          'Оргструктура'
        ),

        a(
          {
            className: 'menu-item menu-item__structure',
            onClick: this.onFavoritesChosen.bind(this),
            href: '#'
          },
          'Избранное'
        ),

        a(
          {
            className: 'menu-item menu-item__structure',
            onClick: this.onToCallChosen.bind(this),
            href: '#'
          },
          'Планировщик'
        ),

        div({ className: 'menu-subtitle' }, 'Дни рождения'),

        a(
          {
            className: 'menu-item menu-item__structure',
            onClick: this.onBirthdaysTodayChosen.bind(this),
            href: '#',
            shortcut: 'today'
          },
          'Сегодня'
        ),

        a(
          {
            className: 'menu-item menu-item__structure',
            onClick: this.onBirthdaysTodayChosen.bind(this),
            href: '#',
            shortcut: 'tomorrow'
          },
          'Будущие'
        ),

        a(
          {
            className: 'menu-item menu-item__structure',
            onClick: this.onBirthdaysTodayChosen.bind(this),
            href: '#',
            shortcut: 'recent'
          },
          'Прошедшие'
        )
      )
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(Menu);
