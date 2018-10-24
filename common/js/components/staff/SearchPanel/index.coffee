import React from 'react'
import PropTypes from 'prop-types'
import { connect } from 'react-redux';
import SvgIcon from '@components/common/SvgIcon'

import { setQuery, resetQuery, sendQuery, setResults } from '@actions/search'
import { popSearchResults } from '@actions/layout'


div = React.createFactory('div')
img = React.createFactory('img')
svg = React.createFactory(SvgIcon)
input = React.createFactory('input')

import Backspace from './icons/backspace.svg'
import HappyBirthday from './icons/happy-birthday.svg'
import HotPhones from './icons/hot-phones.svg'


mapStateToProps = (state, ownProps) ->
  query: state.search.query


mapDispatchToProps = (dispatch, ownProps) ->
  setQuery: (query) ->
    dispatch(setQuery(query))
    if query.match /^\s*$/
      dispatch(setResults([]))
      dispatch(popSearchResults())
    else
      dispatch(sendQuery(query))


class SearchPanel extends React.Component

  onQueryChange: (event) ->
    @props.setQuery(event.target.value)


  onQueryReset: (event) ->
    @props.setQuery('')


  onQueryBlur: (event) ->
    event.currentTarget.focus()


  render: ->
    div { className: 'search-panel-container plug' },
      div { className: 'search-panel' },
        div { className: 'search-panel__input-container' },
          div { className: 'search-panel__input-field' },

            input { autoFocus: true, className: 'search-panel__input', value: @props.query, onChange: @onQueryChange.bind(this), onBlur: @onQueryBlur.bind(this) }
            div { className: 'search-panel__reset', onClick: @onQueryReset.bind(this) },
              svg { className: 'search-panel__reset-icon', svg: Backspace },

        div { className: 'search-panel__buttons-container' },
          div { className: 'search-panel__hot-button' },
            div { className: 'search-panel__hot-button-bg' },
              svg { className: 'search-panel__hot-button-img', svg: HappyBirthday }
          div { className: 'search-panel__hot-button' },
            div { className: 'search-panel__hot-button-bg' },
              svg { className: 'search-panel__hot-button-img', svg: HotPhones }


export default connect(mapStateToProps, mapDispatchToProps)(SearchPanel)
