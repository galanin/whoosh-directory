import React from 'react'
import PropTypes from 'prop-types'
import InlineSVG from 'react-svg-inline'

div = React.createFactory('div')
img = React.createFactory('img')
svg = React.createFactory(InlineSVG)
input = React.createFactory('input')

import Backspace from './icons/backspace.svg'
import HappyBirthday from './icons/happy-birthday.svg'
import HotPhones from './icons/hot-phones.svg'


class SearchPanel extends React.Component
  render: ->
    div { className: 'search-panel plug' },
      div { className: 'search-panel__input-container' },
        input { autoFocus: true, className: 'search-panel__input' }
        div { className: 'search-panel__reset' },
          svg { className: 'search-panel__reset-icon', svg: Backspace },
      div { className: 'search-panel__buttons-container' },
        div { className: 'search-panel__hot-button' },
          div { className: 'search-panel__hot-button-bg' },
            svg { className: 'search-panel__hot-button-img', svg: HappyBirthday }
        div { className: 'search-panel__hot-button' },
          div { className: 'search-panel__hot-button-bg' },
            svg { className: 'search-panel__hot-button-img', svg: HotPhones }


export default SearchPanel
