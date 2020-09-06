/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import React from 'react';
import PropTypes from 'prop-types';
import SvgIcon from '@components/common/SvgIcon';
import classNames from 'classnames';

const svg = React.createFactory(SvgIcon);

import ManSilhouette from '@icons/businessman.svg';
import WomanSilhouette from '@icons/businesswoman.svg';

const silhouettes = {
  M: ManSilhouette,
  F: WomanSilhouette
};


class CommonSilhouette extends React.Component {
  render() {
    const silhouette = silhouettes[this.props.gender] || (Math.random() < .5 ? ManSilhouette : WomanSilhouette);
    const class_names =
      {'common-silhouette' : true};
    class_names[this.props.className] = true;

    return svg({ svg: silhouette, className: classNames(class_names) });
  }
}


export default CommonSilhouette;
