import React from 'react';
import { connect } from 'react-redux';
import classNames from 'classnames';
import { isArray, isEmpty } from 'lodash';

import { FAVORITE_PEOPLE, FAVORITE_UNITS } from '@constants/favorites';
import { showFavoriteEmployments, showFavoriteUnits } from '@actions/favorites';

const div = React.createFactory('div');
const span = React.createFactory('span');

import SomeoneWithButtons from '@components/staff/SomeoneWithButtons';
const someone = React.createFactory(SomeoneWithButtons);

import SearchResultUnit from '@components/staff/SearchResultUnit';
const unit = React.createFactory(SearchResultUnit);

const mapStateToProps = (state, ownProps) => ({
  people: state.favorites.favorite_people,
  units: state.favorites.favorite_units,
  show: state.favorites.show
});

const mapDispatchToProps = dispatch => ({
  showEmployments() {
    return dispatch(showFavoriteEmployments());
  },

  showUnits() {
    return dispatch(showFavoriteUnits());
  }
});

class FavoritesList extends React.Component {
  showEmployments() {
    return this.props.showEmployments();
  }

  showUnits() {
    return this.props.showUnits();
  }

  render() {
    const class_names = {
      'favorites-list': true,
      'favorites-list__scroller': true,
      'favorites-list_employments': this.props.show === FAVORITE_PEOPLE,
      'favorites-list_units': this.props.show === FAVORITE_UNITS
    };
    class_names[this.props.className] = true;

    return div(
      { className: classNames(class_names) },
      div(
        { className: 'favorites-list-container' },
        div(
          { className: 'favorites-list__header' },
          span({ className: 'favorites-list__title' }, 'Избранное'),
          span(
            { className: 'favorites-list__header-buttons' },
            span(
              {
                className:
                  'favorites-list__header-button favorites-list__header-button-employments',
                onClick: this.showEmployments.bind(this)
              },
              'Сотрудники'
            ),
            span(
              {
                className:
                  'favorites-list__header-button favorites-list__header-button-units',
                onClick: this.showUnits.bind(this)
              },
              'Оргструктура'
            )
          )
        ),

        (() => {
          switch (this.props.show) {
            case FAVORITE_PEOPLE:
              if (isArray(this.props.people) && !isEmpty(this.props.people)) {
                return div(
                  { className: 'favorite-list__employments' },
                  (() => {
                    const result = [];
                    for (let favorite_people of this.props.people) {
                      if (favorite_people.employment_id) {
                        result.push(
                          someone({
                            key: favorite_people.employment_id,
                            employment_id: favorite_people.employment_id,
                            className: 'list-item shadow'
                          })
                        );
                      } else if (favorite_people.contact_id) {
                        result.push(
                          someone({
                            key: favorite_people.contact_id,
                            contact_id: favorite_people.contact_id,
                            className: 'list-item shadow'
                          })
                        );
                      } else {
                        result.push(undefined);
                      }
                    }
                    return result;
                  })()
                );
              }
              break;

            case FAVORITE_UNITS:
              if (isArray(this.props.units) && !isEmpty(this.props.units)) {
                return div(
                  { className: 'favorite-list__units' },
                  this.props.units.map(favorite_unit =>
                    unit({
                      key: favorite_unit.unit_id,
                      unit_id: favorite_unit.unit_id,
                      className: 'list-item shadow'
                    })
                  )
                );
              }
              break;
          }
        })()
      )
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(FavoritesList);
