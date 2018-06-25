require './SearchPanel.sass'

import React from 'react'
import PropTypes from 'prop-types'

div = React.createFactory('div')
img = React.createFactory('img')
svg = React.createFactory('svg')
path = React.createFactory('path')
input = React.createFactory('input')

import backspace from './backspace.svg'
import birthday from './happy-birthday.svg'
import hot_phones from './hot-phones.svg'


class SearchPanel extends React.Component
  render: ->
    div { className: 'search-panel plug' },
      div { className: 'search-panel__input-container' },
        input { autoFocus: true, className: 'search-panel__input' }
        div { className: 'search-panel__reset' },
          svg { className: 'search-panel__reset-icon', viewBox: '0 0 48 40' },
            path { d: 'M48 0H12L0 20l12 20h36zM35 30l-7-7-7 7-3-3 7-7-7-7 3-3 7 7 7-7 3 3-7 7 7 7z' }
      div { className: 'search-panel__buttons-container' },
        div { className: 'search-panel__hot-button' },
          div { className: 'search-panel__hot-button-bg' },
            img { src: birthday, className: 'search-panel__hot-button-img' }
        div { className: 'search-panel__hot-button' },
          div { className: 'search-panel__hot-button-bg' },
            img { src: hot_phones, className: 'search-panel__hot-button-img' }


export default SearchPanel
