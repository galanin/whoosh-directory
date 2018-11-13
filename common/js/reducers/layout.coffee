import {
  POP_LAYOUT_BLOCK,
  SINK_LAYOUT_BLOCK,
  LAYOUT_BLOCK_STRUCTURE,
  LAYOUT_BLOCK_UNIT_INFO,
  LAYOUT_BLOCK_EMPLOYEE_INFO,
  LAYOUT_BLOCK_SEARCH_RESULTS,
  LAYOUT_BLOCK_FAVORITES,
  LAYOUT_BLOCK_RECENT,
} from '@constants/layout'

default_layout = [
  LAYOUT_BLOCK_RECENT,
  LAYOUT_BLOCK_FAVORITES,
  LAYOUT_BLOCK_EMPLOYEE_INFO,
  LAYOUT_BLOCK_UNIT_INFO,
  LAYOUT_BLOCK_SEARCH_RESULTS,
  LAYOUT_BLOCK_STRUCTURE,
]

export default (state = { pile: default_layout }, action) ->
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

    else
      state

