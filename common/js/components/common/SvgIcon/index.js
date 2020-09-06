/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import React from 'react';
import PropTypes from 'prop-types';

const span = React.createFactory('span');


class SvgIcon extends React.Component {
  static initClass() {
    this.propTypes = {
      svg: PropTypes.string,
      className: PropTypes.string,
      onClick: PropTypes.func
    };
  }


  render() {
    return span({ className: this.props.className, dangerouslySetInnerHTML: { __html: this.props.svg }, onClick: this.props.onClick });
  }
}
SvgIcon.initClass();


export default SvgIcon;
