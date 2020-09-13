import React from 'react';
import { connect } from 'react-redux';
import classNames from 'classnames';

import { RESULTS_SOURCE_QUERY } from '@constants/search';

import { setQuery } from '@actions/search';
import { setResultsSource } from '@actions/search';
import { popSearchResults } from '@actions/layout';

import SvgIcon from '@components/common/SvgIcon';
import IconedData from '@components/contact_info/IconedData';

import LocationIcon from '@icons/location.svg';

const mapStateToProps = (state, ownProps) => ({});

const mapDispatchToProps = (dispatch, ownProps) => ({
  onClick() {
    const location_str = `${ownProps.building} ${ownProps.office}`;
    dispatch(setQuery(location_str));
    dispatch(setResultsSource(RESULTS_SOURCE_QUERY));
    return dispatch(popSearchResults());
  }
});

class OfficeLocation extends React.Component {
  onClick() {
    return this.props.onClick();
  }

  render() {
    if (this.props.building == null && this.props.office == null) {
      return '';
    }

    const classes = { 'contact-data-office-location': true };
    classes[this.props.className] = true;

    return (
      <IconedData
        className={classNames(classes)}
        icon={LocationIcon}
        align_icon="middle"
        onClick={this.onClick.bind(this)}
      >
        {
          (this.props.building != null ? (
            <div className="iconed-data__row iconed-data__inline">
              <span className="iconed-data__inline-title">Корпус</span>
              <span className="iconed-data__inline-data">
                {this.props.building}
              </span>
            </div>
          ) : (
            undefined
          ),
          this.props.office != null ? (
            <div className="iconed-data__row iconed-data__inline">
              <span className="iconed-data__inline-title">Кабинет</span>
              <span className="iconed-data__inline-data">
                {this.props.office}
              </span>
            </div>
          ) : (
            undefined
          ))
        }
      </IconedData>
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(OfficeLocation);
