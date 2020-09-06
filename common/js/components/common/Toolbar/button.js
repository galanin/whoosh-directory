/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import React from 'react';
import PropTypes from 'prop-types';
import classNames from 'classnames';
import SvgIcon from '@components/common/SvgIcon';

const a = React.createFactory('a');
const div = React.createFactory('div');
const svg = React.createFactory(SvgIcon);


class ToolbarButton extends React.Component {

  render() {

    const class_name = classNames({
      'toolbar-button': true,
      'current-tool': this.props.current
    });

    return a({ className: class_name, href: this.props.href },
      svg({ svg: this.props.svg }),
      div({ className: 'label' },
        this.props.label)
    );
  }
}


export default ToolbarButton;
