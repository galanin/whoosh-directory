import {
  POP_LAYOUT_BLOCK
  SINK_LAYOUT_BLOCK
  LAYOUT_BLOCK_STRUCTURE
  LAYOUT_BLOCK_UNIT_INFO
  LAYOUT_BLOCK_EMPLOYEE_INFO
  LAYOUT_BLOCK_SEARCH_RESULTS
  LAYOUT_BLOCK_BIRTHDAYS
  LAYOUT_BLOCK_FAVORITES
  LAYOUT_BLOCK_RECENT
} from '@constants/layout'

export popUnitInfo = ->
  type: POP_LAYOUT_BLOCK
  layout_block: LAYOUT_BLOCK_UNIT_INFO

export popEmployeeInfo = ->
  type: POP_LAYOUT_BLOCK
  layout_block: LAYOUT_BLOCK_EMPLOYEE_INFO

export sinkEmployeeInfo = ->
  type: SINK_LAYOUT_BLOCK
  layout_block: LAYOUT_BLOCK_EMPLOYEE_INFO

export popSearchResults = ->
  type: POP_LAYOUT_BLOCK
  layout_block: LAYOUT_BLOCK_SEARCH_RESULTS

export popBirthdays = ->
  type: POP_LAYOUT_BLOCK
  layout_block: LAYOUT_BLOCK_BIRTHDAYS

export popStructure = ->
  type: POP_LAYOUT_BLOCK
  layout_block: LAYOUT_BLOCK_STRUCTURE

export popFavorites = ->
  type: POP_LAYOUT_BLOCK
  layout_block: LAYOUT_BLOCK_FAVORITES

export popRecent = ->
  type: POP_LAYOUT_BLOCK
  layout_block: LAYOUT_BLOCK_RECENT
