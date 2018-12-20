import React from 'react'
import BirthdayShortcut from '@components/staff/BirthdayShortcut'


div = React.createFactory('div')
span = React.createFactory('span')
shortcut = React.createFactory(BirthdayShortcut)


class BirthdayShortcutPanel extends React.Component
  render: ->
    div { className: 'birthday-shortcut-panel' },
      span { className: 'birthday-shortcut-panel__title' },
        'Дни рождения'
      shortcut { className: 'birthday-shortcut-panel__shortcut', shortcut: 'today' },
        'Сегодня'
      shortcut { className: 'birthday-shortcut-panel__shortcut', shortcut: 'tomorrow' },
        'Будущие'
      shortcut { className: 'birthday-shortcut-panel__shortcut', shortcut: 'recent' },
        'Прошедшие'


export default BirthdayShortcutPanel
