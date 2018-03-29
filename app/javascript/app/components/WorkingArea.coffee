require './WorkingArea.sass'

import React from 'react'
import PropTypes from 'prop-types'

div = React.createFactory('div')


class WorkingArea extends React.Component
  render: ->
    div { className: 'working-area nailed' },
      div { className: 'working-area__search-panel nail-base' },
        search_panel {}
      div { className: 'working-area__birthday-panel nail-base' }
      div { className: 'working-area__results-panel' },
        div { className: 'working-area__persons nail-base' }
        div { className: 'working-area__structure nail-base' }


export default WorkingArea
