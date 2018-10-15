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

export popUnitInfo = (block) ->
  type: POP_LAYOUT_BLOCK
  layout_block: LAYOUT_BLOCK_UNIT_INFO

export popEmployeeInfo = (block) ->
  type: POP_LAYOUT_BLOCK
  layout_block: LAYOUT_BLOCK_EMPLOYEE_INFO

export sinkEmployeeInfo = (block) ->
  type: SINK_LAYOUT_BLOCK
  layout_block: LAYOUT_BLOCK_EMPLOYEE_INFO

export popSearchResults = (block) ->
  type: POP_LAYOUT_BLOCK
  layout_block: LAYOUT_BLOCK_SEARCH_RESULTS

export popFavorites = (block) ->
  type: POP_LAYOUT_BLOCK
  layout_block: LAYOUT_BLOCK_FAVORITES

export popRecent = (block) ->
  type: POP_LAYOUT_BLOCK
  layout_block: LAYOUT_BLOCK_RECENT
