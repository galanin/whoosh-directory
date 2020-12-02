import React from 'react';
import { connect } from 'react-redux';
import { isMobile } from 'react-device-detect';

import { div, svgIcon, input, menuButton } from '@components/factories';

import { RESULTS_SOURCE_QUERY } from '@constants/search';

import { setQuery, forceQueryResults, setResultsSource } from '@actions/search';
import { popSearchResults } from '@actions/layout';
import { fixText } from '@lib/keyboard_layout_fixer';

import Backspace from './icons/backspace.svg';
import SearchButton from '@icons/search.svg';

const mapStateToProps = (state, ownProps) => ({
  query: state.search.query
});

const mapDispatchToProps = (dispatch, ownProps) => ({
  setQuery(query) {
    dispatch(setQuery(query));
    dispatch(setResultsSource(RESULTS_SOURCE_QUERY));
    return dispatch(popSearchResults());
  },

  forceQuery() {
    dispatch(forceQueryResults());
    dispatch(setResultsSource(RESULTS_SOURCE_QUERY));
    return dispatch(popSearchResults());
  },

  resetQuery() {
    dispatch(setQuery(''));
    dispatch(setResultsSource(RESULTS_SOURCE_QUERY));
    return dispatch(popSearchResults());
  }
});

class SearchPanel extends React.Component {
  constructor(props) {
    super(props);
    this.text_input = React.createRef();
  }

  componentDidUpdate() {
    if (this.cursor_position) {
      return this.text_input.current.setSelectionRange(
        this.cursor_position,
        this.cursor_position
      );
    }
  }

  componentWillUnmount() {
    return clearInterval(this.timer);
  }

  setQueryByEvent(event) {
    const fixed_value = fixText(event.target.value);
    this.cursor_position = event.target.selectionStart;
    return this.props.setQuery(fixed_value);
  }

  onQueryChange(event) {
    return this.setQueryByEvent(event);
  }

  onQueryReset(event) {
    return this.props.resetQuery();
  }

  focusInputIfNoSelection(input) {
    if (window.getSelection()?.isCollapsed) {
      clearInterval(this.timer);
      return input.focus();
    }
  }

  onQueryBlur(event) {
    if (window.getSelection && !isMobile) {
      const inputElement = event.currentTarget;
      return (this.timer = setInterval(() => {
        return this.focusInputIfNoSelection(inputElement);
      }, 1000));
    }
  }

  onQueryExec(event) {
    return this.props.forceQuery();
  }

  onKeyDown(event) {
    if (event.keyCode === 13) {
      return this.setQueryByEvent(event);
    }
  }

  render() {
    return div(
      { className: 'search-panel-container plug' },
      div(
        { className: 'search-panel' },
        menuButton({}),

        div(
          { className: 'search-panel__input-container' },
          div({ className: 'search-panel__input-title' }, 'Поиск'),
          div(
            { className: 'search-panel__input-field soft-shadow' },

            input({
              autoFocus: !isMobile,
              className: 'search-panel__input',
              ref: this.text_input,
              value: this.props.query,
              onChange: this.onQueryChange.bind(this),
              onBlur: this.onQueryBlur.bind(this),
              onClick: this.onQueryExec.bind(this),
              onKeyUp: this.onKeyDown.bind(this)
            }),
            div(
              {
                className: 'search-panel__reset',
                onClick: this.onQueryReset.bind(this)
              },
              svgIcon({ className: 'search-panel__reset-icon', svg: Backspace })
            )
          ),

          div(
            {
              className: 'search-panel__search',
              onClick: this.onQueryExec.bind(this)
            },
            svgIcon({ className: 'search-panel__search-icon', svg: SearchButton })
          )
        )
      )
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(SearchPanel);
