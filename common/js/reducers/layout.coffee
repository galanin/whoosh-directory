import {
  POP_LAYOUT_BLOCK,
} from '@constants/layout'

export default (state = {}, action) ->
  switch action.type
    when POP_LAYOUT_BLOCK
      new_top_block = action.layout_block
      order = state.block_z_order
      [..., top_block] = order
      unless to_block == new_top_block
        new_z_order = order.filter (word) -> word isnt new_top_block
        new_z_order.push new_top_block
        { block_z_order: new_z_order }
    else
      state
