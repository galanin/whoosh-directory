import React from 'react'
import PropTypes from 'prop-types'
import { connect } from 'react-redux';
import SvgIcon from '@components/common/SvgIcon'

import { setQuery } from '@actions/search'
import { popSearchResults } from '@actions/layout'


div = React.createFactory('div')
img = React.createFactory('img')
svg = React.createFactory(SvgIcon)
input = React.createFactory('input')

import Backspace from './icons/backspace.svg'
import SearchButton from '@icons/search.svg'


mapStateToProps = (state, ownProps) ->
  query: state.search.query


mapDispatchToProps = (dispatch, ownProps) ->
  setQuery: (query) ->
    dispatch(setQuery(query))
    dispatch(popSearchResults())

  resetQuery: ->
    dispatch(setQuery(''))
    dispatch(popSearchResults())

  returnToQuery: ->
    dispatch(popSearchResults())


class SearchPanel extends React.Component

  componentWillUnmount: ->
    clearInterval(@timer)


  onQueryChange: (event) ->
    @props.setQuery(event.target.value)


  onQueryReset: (event) ->
    @props.resetQuery()


  focusInputIfNoSelection: (input) ->
    if window.getSelection
      if window.getSelection()?.isCollapsed
        clearInterval(@timer)
        input.focus()


  onQueryBlur: (event) ->
    inputElement = event.currentTarget
    @timer = setInterval =>
      @focusInputIfNoSelection(inputElement)
    , 1000


  onQueryExec: ->
    @props.returnToQuery()


  render: ->
    div { className: 'search-panel-container plug' },
      div { className: 'search-panel' },
        div { className: 'search-panel__input-container' },
          div { className: 'search-panel__input-field' },

            input { autoFocus: true, className: 'search-panel__input', value: @props.query, onChange: @onQueryChange.bind(this), onBlur: @onQueryBlur.bind(this) }
            div { className: 'search-panel__reset', onClick: @onQueryReset.bind(this) },
              svg { className: 'search-panel__reset-icon', svg: Backspace },

          div { className: 'search-panel__search', onClick: @onQueryExec.bind(this) },
            svg { className: 'search-panel__search-icon', svg: SearchButton },


export default connect(mapStateToProps, mapDispatchToProps)(SearchPanel)
