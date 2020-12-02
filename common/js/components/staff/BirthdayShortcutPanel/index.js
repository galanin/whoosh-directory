import React from 'react';
import classNames from 'classnames';

import { div, span, birthdayShortcut } from '@components/factories';

class BirthdayShortcutPanel extends React.Component {
  render() {
    const class_names = { 'birthday-shortcut-panel': true };
    class_names[this.props.className] = true;

    return div(
      { className: classNames(class_names) },
      span({ className: 'birthday-shortcut-panel__title' }, 'Дни рождения'),
      birthdayShortcut(
        { className: 'birthday-shortcut-panel__shortcut', shortcut: 'today' },
        'Сегодня'
      ),
      birthdayShortcut(
        {
          className: 'birthday-shortcut-panel__shortcut',
          shortcut: 'tomorrow'
        },
        'Будущие'
      ),
      birthdayShortcut(
        { className: 'birthday-shortcut-panel__shortcut', shortcut: 'recent' },
        'Прошедшие'
      )
    );
  }
}

export default BirthdayShortcutPanel;
