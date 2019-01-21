import { isEqual } from 'lodash'

import { LOCATION_CHANGE } from 'connected-react-router'
import { getNewUrlParam } from '@lib/url-parsing'
import { URL_PARAM_LAYOUT } from '@constants/url-parsing'

import { unpackLayout } from '@lib/layout'

import {
  DEFAULT_LAYOUT,
  LAYOUT_BLOCK_EMPLOYEE_INFO,
  LAYOUT_BLOCK_FAVORITES,
  LAYOUT_BLOCK_RECENT,
  LAYOUT_BLOCK_SEARCH_RESULTS,
  LAYOUT_BLOCK_STRUCTURE,
  LAYOUT_BLOCK_UNIT_INFO,
  POP_LAYOUT_BLOCK,
  SINK_LAYOUT_BLOCK
} from '@constants/layout'

export default (state = { pile: DEFAULT_LAYOUT }, action) ->
  switch action.type

    when POP_LAYOUT_BLOCK
      new_top_block = action.layout_block
      unless state.pile[state.pile.length - 1] == new_top_block
        new_z_order = state.pile.filter (block) -> block isnt new_top_block
        new_z_order.push new_top_block
        new_state = Object.assign({}, state)
        new_state.pile = new_z_order
        new_state
      else
        state

    when SINK_LAYOUT_BLOCK
      new_bottom_block = action.layout_block
      unless state.pile[0] == new_bottom_block
        new_z_order = state.pile.filter (block) -> block isnt new_bottom_block
        new_z_order.unshift new_bottom_block
        new_state = Object.assign({}, state)
        new_state.pile = new_z_order
        new_state
      else
        state

    when LOCATION_CHANGE
      if action.payload.action == 'POP'
        layout_packed = getNewUrlParam(action.payload, URL_PARAM_LAYOUT)

        new_state = Object.assign({}, state)

        if layout_packed?
          new_layout = unpackLayout(layout_packed)
          if isEqual(new_layout, state.pile)
            state
          else
            new_state.pile = new_layout
        else
          new_state.pile = DEFAULT_LAYOUT

        new_state

      else
        state

    else
      state

