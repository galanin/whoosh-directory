import React from 'react';
import PropTypes from 'prop-types';
import classNames from 'classnames';

import { svgIcon } from '@components/factories';

import ManSilhouette from '@icons/businessman.svg';
import WomanSilhouette from '@icons/businesswoman.svg';

const silhouettes = {
  M: ManSilhouette,
  F: WomanSilhouette
};

class CommonSilhouette extends React.Component {
  render() {
    const silhouette =
      silhouettes[this.props.gender] ||
      (Math.random() < 0.5 ? ManSilhouette : WomanSilhouette);
    const class_names = { 'common-silhouette': true };
    class_names[this.props.className] = true;

    return svgIcon({ svg: silhouette, className: classNames(class_names) });
  }
}

export default CommonSilhouette;
