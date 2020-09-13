import React from 'react';
import PropTypes from 'prop-types';

class SvgIcon extends React.Component {
  render() {
    return (
      <span
        className={this.props.className}
        dangerouslySetInnerHTML={{ __html: `${this.props.svg}` }}
        onClick={this.props.onClick}
      ></span>
    );
  }
}

SvgIcon.propTypes = {
  svg: PropTypes.string,
  className: PropTypes.string,
  onClick: PropTypes.func
};

export default SvgIcon;
