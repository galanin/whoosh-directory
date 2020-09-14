import React from 'react';
import classNames from 'classnames';
import BirthdayShortcut from '@components/staff/BirthdayShortcut';

const div = React.createFactory('div');
const span = React.createFactory('span');
const shortcut = React.createFactory(BirthdayShortcut);

class BirthdayShortcutPanel extends React.Component {
  render() {
    const class_names = { 'birthday-shortcut-panel': true };
    class_names[this.props.className] = true;

    return div(
      { className: classNames(class_names) },
      span({ className: 'birthday-shortcut-panel__title' }, 'Дни рождения'),
      shortcut(
        { className: 'birthday-shortcut-panel__shortcut', shortcut: 'today' },
        'Сегодня'
      ),
      shortcut(
        {
          className: 'birthday-shortcut-panel__shortcut',
          shortcut: 'tomorrow'
        },
        'Будущие'
      ),
      shortcut(
        { className: 'birthday-shortcut-panel__shortcut', shortcut: 'recent' },
        'Прошедшие'
      )
    );
  }
}

export default BirthdayShortcutPanel;
